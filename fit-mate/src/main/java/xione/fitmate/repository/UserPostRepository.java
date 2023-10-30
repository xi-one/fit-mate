package xione.fitmate.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import xione.fitmate.domain.BoardPost;
import xione.fitmate.domain.User;
import xione.fitmate.domain.UserPost;

import java.util.List;

public interface UserPostRepository extends JpaRepository<UserPost, Long> {
    List<UserPost> findAllByPost(BoardPost post);
    boolean existsByUserAndPost(User user, BoardPost post);

    @Query("SELECT u.post FROM UserPost u WHERE u.user=:user")
    List<BoardPost> getPostByUser(@Param("user") User user);

}
