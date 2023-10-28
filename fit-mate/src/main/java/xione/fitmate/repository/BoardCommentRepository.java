package xione.fitmate.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import xione.fitmate.domain.BoardComment;
import xione.fitmate.domain.BoardPost;

import java.util.List;

public interface BoardCommentRepository extends JpaRepository<BoardComment, Long> {
    List<BoardComment> findAllByPostId(BoardPost boardPost);
}
