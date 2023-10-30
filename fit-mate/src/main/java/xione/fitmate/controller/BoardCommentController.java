package xione.fitmate.controller;

import lombok.RequiredArgsConstructor;
import org.hibernate.hql.spi.id.local.LocalTemporaryTableBulkIdStrategy;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import xione.fitmate.domain.BoardComment;
import xione.fitmate.domain.BoardPost;
import xione.fitmate.domain.Sex;
import xione.fitmate.domain.User;
import xione.fitmate.payload.request.RegisterCommentRequest;
import xione.fitmate.payload.request.RegisterUserInfoRequest;
import xione.fitmate.payload.response.Comment;
import xione.fitmate.payload.response.CommentsResponse;
import xione.fitmate.payload.response.StatusResponse;
import xione.fitmate.payload.response.UserInfoResponse;
import xione.fitmate.repository.BoardCommentRepository;
import xione.fitmate.repository.BoardPostRepository;
import xione.fitmate.repository.UserRepository;
import xione.fitmate.security.oauth2.CustomUserDetails;
import xione.fitmate.service.UserInfoService;

import javax.validation.Valid;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/comment")
@RequiredArgsConstructor
public class BoardCommentController {
    private final UserInfoService userinfoService;
    private final UserRepository userRepository;
    private final BoardPostRepository boardPostRepository;
    private final BoardCommentRepository boardCommentRepository;


    @PostMapping
    public ResponseEntity<?> registerComment(@Valid @RequestBody RegisterCommentRequest commentRequest) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = Long.valueOf(userDetails.getName());

        if(!userId.equals(commentRequest.getUserId())) {
            throw new IllegalArgumentException("user Id is different: " + userId + " " + commentRequest.getUserId());
        }

        String content = commentRequest.getContent();
        User user = userRepository.findById(commentRequest.getUserId()).orElseThrow(IllegalAccessError::new);
        BoardPost post = boardPostRepository.findById(commentRequest.getPostId()).orElseThrow(IllegalAccessError::new);

        BoardComment comment = new BoardComment();
        comment.setContent(commentRequest.getContent());
        comment.setPostId(post);
        comment.setUserId(user);
        boardCommentRepository.save(comment);



        return ResponseEntity.status(HttpStatus.OK).body(new StatusResponse("Comment registered successfully!"));    }

    @GetMapping("/{post_id}")
    public ResponseEntity<?> readComments( @PathVariable Long post_id) {
        BoardPost post = boardPostRepository.findById(post_id).orElseThrow(IllegalAccessError::new);
        List<BoardComment> BoardComments = boardCommentRepository.findAllByPostId(post);

        List<Comment> comments = new ArrayList<>();
        for(int i = 0; i < BoardComments.size(); i++) {
            BoardComment curComment = BoardComments.get(i);
            comments.add(new Comment(
                    curComment.getId(),
                    curComment.getContent(),
                    curComment.getCreated_at(),
                    curComment.getPostId().getId(),
                    curComment.getUserId().getName(),
                    curComment.getUserId().getId()
            ));
        }
        CommentsResponse response =
                new CommentsResponse(post_id, comments);

        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
}
