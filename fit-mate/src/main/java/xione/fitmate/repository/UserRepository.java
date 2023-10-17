package xione.fitmate.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import xione.fitmate.domain.Sex;
import xione.fitmate.domain.User;

import java.time.LocalDate;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    @Query("SELECT u.refreshToken FROM User u WHERE u.id=:id")
    String getRefreshTokenById(@Param("id") Long id);

    @Transactional
    @Modifying
    @Query("UPDATE User u SET u.refreshToken=:token WHERE u.id=:id")
    void updateRefreshToken(@Param("id") Long id, @Param("token") String token);

    @Transactional
    @Modifying
    @Query("UPDATE User u SET u.cash =0, u.sex = :sex, u.birth = :birth, u.region = :region, u.sports = :sports WHERE u.id = :id")
    void updateSexAndBirthById(@Param("id") Long id, @Param("sex") Sex sex, @Param("birth") LocalDate birth, @Param("region") String region,  @Param("sports") String sports);
}
