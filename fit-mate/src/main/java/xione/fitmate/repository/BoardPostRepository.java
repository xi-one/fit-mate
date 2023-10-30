package xione.fitmate.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import xione.fitmate.domain.BoardPost;
import xione.fitmate.domain.User;

import java.util.List;

public interface BoardPostRepository extends JpaRepository<BoardPost, Long> {
    List<BoardPost> findAllByisRecruiting(boolean isRecruiting);
    List<BoardPost> findAllByUserId(User user);



}
