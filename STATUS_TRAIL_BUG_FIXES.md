# Status Trail Bug Fixes - Summary

## Issues Fixed

### 1. Missing initial status trails when creating orders locally
**Problem**: When orders were created locally (not from NLIMS), they had no order_status and test_status, resulting in null values and empty arrays.

**Solution**: Added automatic creation of initial status trails:
- **Order status trail**: Created with status "ordered" when `order_test` is called
- **Test status trails**: Created for each test with status "ordered" when tests are created
- Both include timestamp and user information (first name, last name, user ID)

**Files Modified**:
- [orders_service.rb](app/services/lab/orders_service.rb):
  - Added `create_initial_order_status_trail` method
  - Calls it in `order_test` after order creation
  - Reloads order with status trails before serialization
  
- [tests_service.rb](app/services/lab/tests_service.rb):
  - Added `create_initial_test_status_trail` method
  - Calls it in `create_tests` for each test created

### 2. Status trails not extracted from NLIMS when pulling orders
**Problem**: When the lab order job (UpdatePatientOrdersJob) pulled orders from NLIMS, it wasn't extracting and saving the status trail information from the NLIMS response, even when tests had no results yet.

**Solution**: Enhanced PullWorker to extract and save status trails from NLIMS:
- Extracts order status trails from `sample_statuses` in NLIMS order data
- Extracts test status trails from `test_statuses` for each test
- Saves all status trail entries to the database
- Prevents duplicate entries using existence checks

**Files Modified**:
- [pull_worker.rb](app/services/lab/lims/pull_worker.rb):
  - Added `save_status_trails_from_nlims` method (called from both `create_order` and `update_order`)
  - Added `save_order_status_trails` method to process order status trails
  - Added `save_test_status_trails` method to process test status trails
  - Parses NLIMS timestamp format (YYYYMMDDHHmmss)
  - Handles errors gracefully with warning logs

## Data Flow

### When Creating a New Order Locally:
```
1. OrdersService.order_test called
2. Order created in database
3. Initial order status trail created (status: "ordered")
4. Tests created via TestsService.create_tests
5. Initial test status trails created for each test (status: "ordered")
6. Order reloaded with all associations (including status trails)
7. Serialized response includes order_status and test_status fields
```

### When Pulling from NLIMS:
```
1. UpdatePatientOrdersJob runs
2. PullWorker.pull_orders fetches order data from NLIMS
3. For each order:
   a. Order created or updated locally
   b. Status trails extracted from order_dto['sample_statuses']
   c. Test status trails extracted from order_dto['test_statuses']
   d. All status trails saved to database (with duplicate prevention)
   e. Results updated if present
4. Response includes complete status history from NLIMS
```

## API Response Format

### Before Fix:
```json
{
  "order_status": null,
  "order_status_trail": [],
  "tests": [{
    "test_status": null,
    "test_status_trail": []
  }]
}
```

### After Fix:
```json
{
  "order_status": {
    "status_id": 1,
    "status": "ordered",
    "timestamp": "2026-02-25T00:00:00.000+02:00",
    "updated_by": {
      "first_name": "admin",
      "last_name": null,
      "id": "1",
      "phone_number": null
    }
  },
  "order_status_trail": [
    {
      "status_id": 1,
      "status": "ordered",
      "timestamp": "2026-02-25T00:00:00.000+02:00",
      "updated_by": { ... }
    }
  ],
  "tests": [{
    "test_status": {
      "status_id": 1,
      "status": "ordered",
      "timestamp": "2026-02-25T00:00:00.000+02:00",
      "updated_by": { ... }
    },
    "test_status_trail": [
      {
        "status_id": 1,
        "status": "ordered",
        "timestamp": "2026-02-25T00:00:00.000+02:00",
        "updated_by": { ... }
      }
    ]
  }]
}
```

## Benefits

1. **Complete Audit Trail**: Every order and test now has a status from creation
2. **NLIMS Integration**: Full status history is preserved when syncing with NLIMS
3. **Works Without Results**: Status trails are saved even when tests don't have results yet
4. **No Duplicates**: Automatic duplicate prevention ensures data integrity
5. **Error Resilient**: All status trail operations are wrapped in error handling

## Testing

Test the implementation by:

1. **Create a new order locally**:
   ```ruby
   POST /lab/orders
   # Response should include order_status and test_status
   ```

2. **Pull orders from NLIMS**:
   ```ruby
   # Trigger UpdatePatientOrdersJob
   Lab::UpdatePatientOrdersJob.perform_now(patient_id)
   
   # Verify status trails are populated
   order = Lab::LabOrder.includes(:status_trails, tests: [:status_trails]).first
   order.status_trails # Should have entries from NLIMS
   order.tests.first.status_trails # Should have entries from NLIMS
   ```

3. **Verify API response**:
   ```ruby
   GET /lab/orders?patient_id=123
   # All orders should have order_status and order_status_trail
   # All tests should have test_status and test_status_trail
   ```
