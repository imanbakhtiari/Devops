# Potential Impacts of Changing `wal_level` to `logical`

## Increased WAL Volume

- **Impact**: Logical replication generates more detailed WAL records compared to the `replica` setting. This can lead to increased disk usage as the WAL files will be larger and more numerous.
- **Consideration**: Ensure that your storage system can handle the increased WAL volume. Monitor disk space and performance to manage the impact.

## Performance Overhead

- **Impact**: The additional logging can introduce a performance overhead. This might affect write performance since more information is being logged.
- **Consideration**: Monitor the performance of your database and consider optimizing your PostgreSQL configuration to mitigate any performance impacts.

## Logical Replication Slots

- **Impact**: With `wal_level` set to `logical`, you will need to manage logical replication slots. If these slots are not consumed or if they are not managed properly, they can lead to WAL bloat and increased disk usage.
- **Consideration**: Regularly monitor the state of logical replication slots and clean up unused or old slots to prevent issues.

## Configuration Complexity

- **Impact**: Setting up logical replication requires additional configuration, including creating publications and subscriptions. This adds complexity to your PostgreSQL setup.
- **Consideration**: Make sure you are familiar with logical replication setup and management. Properly configure and test replication to ensure it meets your needs.

## Patroni Failover and Recovery

- **Impact**: Changing `wal_level` should not directly impact Patroni’s failover mechanism, but the failover process might be affected by the increased WAL volume or the configuration complexity.
- **Consideration**: Ensure that Patroni’s failover and recovery processes are well-tested after making the change. Verify that replication and CDC continue to function correctly during and after failover events.

# Summary of Considerations

- **Disk Usage**: Be prepared for increased disk usage due to larger and more frequent WAL files.
- **Performance**: Monitor and potentially adjust PostgreSQL configuration to handle the additional logging overhead.
- **Replication Slots**: Manage and monitor logical replication slots to prevent WAL bloat.
- **Complexity**: Be prepared for additional configuration and setup for logical replication.
- **Failover**: Ensure that failover mechanisms continue to work smoothly with the new `wal_level` setting.

# Best Practices

1. **Test Thoroughly**: Before making changes in production, test the impact of `wal_level` changes in a staging environment that mirrors your production setup.
2. **Monitor Closely**: After applying the change, closely monitor disk usage, performance metrics, and replication status.
3. **Optimize Configurations**: Fine-tune PostgreSQL settings related to WAL and replication to balance performance and data capture needs.

Changing `wal_level` to `logical` is a common requirement for CDC and logical replication, and with proper management and monitoring, it can be integrated into a Patroni-managed PostgreSQL setup effectively.

