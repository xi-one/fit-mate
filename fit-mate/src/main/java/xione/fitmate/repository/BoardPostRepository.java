package xione.fitmate.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import xione.fitmate.domain.BoardPost;

import java.util.List;

public interface BoardPostRepository extends JpaRepository<BoardPost, Long> {
    List<BoardPost> findByisRecruiting(boolean isRecruiting);
}
