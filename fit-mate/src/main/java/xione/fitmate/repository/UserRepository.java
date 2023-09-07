package xione.fitmate.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import xione.fitmate.domain.User;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);
}
