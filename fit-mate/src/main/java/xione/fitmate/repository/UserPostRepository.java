package xione.fitmate.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import xione.fitmate.domain.BoardPost;
import xione.fitmate.domain.UserPost;

import java.util.List;

public interface UserPostRepository extends JpaRepository<UserPost, Long> {
    List<UserPost> findAllByPost(BoardPost post);
}
