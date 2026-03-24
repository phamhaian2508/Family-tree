package com.javaweb.repository;

import com.javaweb.entity.ActivityLogEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;

public interface ActivityLogRepository extends JpaRepository<ActivityLogEntity, Long> {
    List<ActivityLogEntity> findTop100ByOrderByTimestampDesc();
    List<ActivityLogEntity> findByTimestampBetweenOrderByTimestampAsc(Date from, Date to);
    List<ActivityLogEntity> findByActionAndTimestampBetweenOrderByTimestampAsc(String action, Date from, Date to);
    long countByTimestampAfter(Date since);
    long countByActionAndTimestampAfter(String action, Date since);
    long countByActionInAndTimestampAfter(List<String> actions, Date since);

    @Query("select a from ActivityLogEntity a join fetch a.user order by a.timestamp desc")
    List<ActivityLogEntity> findRecentWithUser(Pageable pageable);
}

