package xione.fitmate.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import xione.fitmate.domain.TokenHistory;
import xione.fitmate.domain.User;

import java.util.List;

public interface TokenHistoryRepository extends JpaRepository<TokenHistory, Long> {
    List<TokenHistory> findAllByUser(User user);
}
