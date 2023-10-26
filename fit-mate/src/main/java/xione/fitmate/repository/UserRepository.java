package xione.fitmate.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import xione.fitmate.domain.Sex;
import xione.fitmate.domain.User;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    @Transactional
    @Modifying
    @Query("UPDATE User u SET u.sports = :newSports WHERE u.id = :userId")
    void updateSportsForUser(@Param("userId") Long userId, @Param("newSports") List<String> newSports);

    @Query("SELECT u.refreshToken FROM User u WHERE u.id=:id")
    String getRefreshTokenById(@Param("id") Long id);

    @Transactional
    @Modifying
    @Query("UPDATE User u SET u.refreshToken=:token WHERE u.id=:id")
    void updateRefreshToken(@Param("id") Long id, @Param("token") String token);


}
