# Order and Test Status Trail Implementation

## Overview

This implementation adds support for tracking order-level and test-level status histories (status trails) in the HIS EMR API Lab gem. Previously, the system operated on a one-order-one-test model with simple status tracking. Now it supports one-order-multiple-tests with independent status trails for both orders and individual tests.

## Database Changes

### Migrations Created

1. **`20260225120000_create_lab_order_status_trails.rb`**
   - Creates `lab_order_status_trails` table
   - Stores historical status updates for orders
   - Fields: order_id, status_id, status, timestamp, updated_by information

2. **`20260225120001_create_lab_test_status_trails.rb`**
   - Creates `lab_test_status_trails` table
   - Stores historical status updates for individual tests
   - Fields: test_id, status_id, status, timestamp, updated_by information

### Running Migrations

```bash
cd /home/hopgausi/HisMalawi/his_emr_api_lab
rails db:migrate
```

## Models Created

### `Lab::OrderStatusTrail`

- Tracks order status history
- Belongs to `Lab::LabOrder`
- Provides `updated_by` method that returns updater information

### `Lab::TestStatusTrail`

- Tracks test status history
- Belongs to `Lab::LabTest`
- Provides `updated_by` method that returns updater information

## Model Updates

### `Lab::LabOrder`

- Added `has_many :status_trails` association
- Updated `prefetch_relationships` to include status trails

### `Lab::LabTest`

- Added `has_many :status_trails` association
- Included in `prefetch_relationships`

## Service Updates

### `Lab::OrdersService`

#### New Methods

1. **`save_order_status_trail(order, status_params)`**
   - Saves a single order status trail entry
   - Called from `update_order_status`

2. **`save_order_status_trails_from_nlims(order, status_trail)`**
   - Processes and saves order status trail array from NLIMS
   - Prevents duplicate entries

3. **`save_test_status_trails_from_nlims(order, tests)`**
   - Processes and saves test status trail arrays from NLIMS
   - Matches tests by concept and saves their status histories
   - Prevents duplicate entries

#### Updated Methods

1. **`update_order_status(order_params)`**
   - Now saves order status trail in addition to observation
   - Maintains backward compatibility

2. **`update_order_result(order_params)`**
   - Enhanced to handle NLIMS payload structure
   - Extracts and saves order status trails
   - Extracts and saves test status trails
   - Processes test results from NLIMS format
   - Backward compatible with old format

## Serializer Updates

### `Lab::LabOrderSerializer`

#### New Fields in Order Serialization

- **`order_status`**: Latest order status with timestamp and updater
- **`order_status_trail`**: Complete history of order statuses

#### New Fields in Test Serialization

- **`test_status`**: Latest test status with timestamp and updater
- **`test_status_trail`**: Complete history of test statuses

#### New Helper Methods

1. **`latest_order_status(order)`** - Returns most recent order status
2. **`serialize_order_status_trail(order)`** - Returns full order status history
3. **`latest_test_status(test)`** - Returns most recent test status
4. **`serialize_test_status_trail(test)`** - Returns full test status history

## Controller Updates

### `Lab::OrdersController`

#### `order_status` endpoint

- Now accepts `status_id` and `updated_by` parameters
- Saves status trail information when provided

#### `order_result` endpoint

- Handles nested NLIMS payload structure
- Processes order and test status trails from NLIMS

## API Usage Examples

### 1. Update Order Status (Simple)

```ruby
POST /lab/orders/order_status
{
  "tracking_number": "XLLH12345",
  "status": "specimen_collected",
  "status_time": "2026-02-25T10:30:00Z",
  "status_id": 2,
  "updated_by": {
    "first_name": "John",
    "last_name": "Doe",
    "id": "123456",
    "phone_number": "+265888123456"
  }
}
```

### 2. Update Order with Results and Status Trails (NLIMS Format)

```ruby
POST /lab/orders/order_result
{
  "data": {
    "order": {
      "uuid": "abc-123",
      "tracking_number": "XLLH12345",
      "sample_type": { "name": "Blood" },
      "sample_status": { "name": "Collected" },
      "status_trail": [
        {
          "status_id": 1,
          "status": "ordered",
          "timestamp": "2026-02-25T08:00:00Z",
          "updated_by": {
            "first_name": "Jane",
            "last_name": "Smith",
            "id": "789",
            "phone_number": "+265999876543"
          }
        },
        {
          "status_id": 2,
          "status": "specimen_collected",
          "timestamp": "2026-02-25T09:00:00Z",
          "updated_by": {
            "first_name": "John",
            "last_name": "Doe",
            "id": "123",
            "phone_number": "+265888123456"
          }
        }
      ]
    },
    "patient": { ... },
    "tests": [
      {
        "tracking_number": "XLLH12345",
        "test_type": {
          "name": "Viral Load",
          "nlims_code": "VL"
        },
        "test_status": "completed",
        "status_trail": [
          {
            "status_id": 1,
            "status": "pending",
            "timestamp": "2026-02-25T08:00:00Z",
            "updated_by": {
              "first_name": "Jane",
              "last_name": "Smith",
              "id": "789",
              "phone_number": "+265999876543"
            }
          },
          {
            "status_id": 2,
            "status": "in_progress",
            "timestamp": "2026-02-25T09:00:00Z",
            "updated_by": {
              "first_name": "Lab",
              "last_name": "Technician",
              "id": "456",
              "phone_number": "+265777654321"
            }
          },
          {
            "status_id": 3,
            "status": "completed",
            "timestamp": "2026-02-25T10:00:00Z",
            "updated_by": {
              "first_name": "Lab",
              "last_name": "Technician",
              "id": "456",
              "phone_number": "+265777654321"
            }
          }
        ],
        "test_results": [
          {
            "measure": {
              "name": "HIV Viral Load",
              "nlims_code": "VL"
            },
            "result": {
              "value": "1000",
              "unit": "copies/ml",
              "result_date": "2026-02-25T10:00:00Z"
            }
          }
        ]
      }
    ]
  }
}
```

### 3. Retrieve Orders with Status Trails

```ruby
GET /lab/orders?patient_id=123
```

**Response:**

```json
[
  {
    "id": 456,
    "order_id": 456,
    "accession_number": "XLLH12345",
    "order_date": "2026-02-25",
    "order_status": {
      "status_id": 2,
      "status": "specimen_collected",
      "timestamp": "2026-02-25T09:00:00Z",
      "updated_by": {
        "first_name": "John",
        "last_name": "Doe",
        "id": "123",
        "phone_number": "+265888123456"
      }
    },
    "order_status_trail": [
      {
        "status_id": 1,
        "status": "ordered",
        "timestamp": "2026-02-25T08:00:00Z",
        "updated_by": { ... }
      },
      {
        "status_id": 2,
        "status": "specimen_collected",
        "timestamp": "2026-02-25T09:00:00Z",
        "updated_by": { ... }
      }
    ],
    "tests": [
      {
        "id": 789,
        "name": "Viral Load",
        "test_status": {
          "status_id": 3,
          "status": "completed",
          "timestamp": "2026-02-25T10:00:00Z",
          "updated_by": { ... }
        },
        "test_status_trail": [
          {
            "status_id": 1,
            "status": "pending",
            "timestamp": "2026-02-25T08:00:00Z",
            "updated_by": { ... }
          },
          {
            "status_id": 2,
            "status": "in_progress",
            "timestamp": "2026-02-25T09:00:00Z",
            "updated_by": { ... }
          },
          {
            "status_id": 3,
            "status": "completed",
            "timestamp": "2026-02-25T10:00:00Z",
            "updated_by": { ... }
          }
        ],
        "result": { ... }
      }
    ]
  }
]
```

## Backward Compatibility

The implementation maintains full backward compatibility:

1. **Observations**: Order statuses are still saved as observations for existing code
2. **Old API format**: The `update_order_result` method still accepts the old format
3. **Existing queries**: `OrdersSearchService.find_orders` works as before, now with additional status information

## Key Features

1. **Full Status History**: Complete audit trail of all status changes for orders and tests
2. **User Tracking**: Captures who made each status change with full details
3. **Timestamp Tracking**: Precise timestamps for each status change
4. **Duplicate Prevention**: Automatically prevents duplicate status trail entries
5. **NLIMS Integration**: Seamlessly handles NLIMS payload structure
6. **Performance Optimized**: Uses eager loading to prevent N+1 queries

## Testing

After running migrations, test the implementation:

```bash
# Run the test suite
rspec

# Start the console to test manually
rails console

# Example: Create a test order with status trail
order = Lab::LabOrder.first
order.status_trails.create!(
  status_id: 1,
  status: 'ordered',
  timestamp: Time.now,
  updated_by_first_name: 'Test',
  updated_by_last_name: 'User',
  updated_by_id: '123'
)

# Verify serialization includes status trails
Lab::LabOrderSerializer.serialize_order(order)
```

## Notes

- Status trails are stored separately from OpenMRS observations for better querying and performance
- The `status_id` field maps to NLIMS status IDs for integration purposes
- All timestamps should be in ISO 8601 format
- The implementation handles both individual status updates and batch status trail imports from NLIMS
