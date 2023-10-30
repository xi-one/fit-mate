package xione.fitmate.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import xione.fitmate.domain.BoardPost;
import xione.fitmate.domain.User;
import xione.fitmate.domain.UserPost;
import xione.fitmate.payload.request.RegisterPostRequest;
import xione.fitmate.payload.request.SetRecruitingRequest;
import xione.fitmate.payload.response.PostsResponse;
import xione.fitmate.payload.response.PostDetailResponse;
import xione.fitmate.payload.response.StatusResponse;
import xione.fitmate.repository.BoardPostRepository;
import xione.fitmate.repository.UserPostRepository;
import xione.fitmate.repository.UserRepository;
import xione.fitmate.security.oauth2.CustomUserDetails;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;
@Log4j2
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardPostController {

    private final UserRepository userRepository;
    private final BoardPostRepository boardPostRepository;
    private final UserPostRepository userPostRepository;


    @PostMapping
    public ResponseEntity<?> registerPost(@Valid @RequestBody RegisterPostRequest postRequest) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = Long.valueOf(userDetails.getName());

        if(!userId.equals(postRequest.getUserId())) {
            throw new IllegalArgumentException("user Id is different");
        }
        User user = userRepository.findById(postRequest.getUserId()).orElseThrow(IllegalAccessError::new);


        BoardPost post = new BoardPost();

        post.setUserId(user);
        post.setTitle(postRequest.getTitle());
        post.setContent(postRequest.getContent());
        post.setLocation(postRequest.getLocation());
        post.setSports(postRequest.getSports());
        post.setNumOfRecruits(postRequest.getNumOfRecruits());
        post.setRecruiting(true);

        BoardPost result = boardPostRepository.save(post);
        UserPost userpost = new UserPost(user, result);
        userPostRepository.save(userpost);


        return ResponseEntity.status(HttpStatus.OK).body(new StatusResponse("post registered successfully!"));    }

    @PostMapping("/recruiting")
    public ResponseEntity<?> setRecruitingState(@Valid @RequestBody SetRecruitingRequest recruitingRequest) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = Long.valueOf(userDetails.getName());

        if(!userId.equals(recruitingRequest.getUserId())) {
            throw new IllegalArgumentException("user Id is different");
        }

        BoardPost post = boardPostRepository.findById(recruitingRequest.getPostId()).orElseThrow(IllegalAccessError::new);
        if(!userId.equals(post.getUserId().getId())) {
            throw new IllegalArgumentException("requester is different from writer");
        }
        post.setRecruiting(recruitingRequest.isRecruiting());
        boardPostRepository.save(post);

        return ResponseEntity.status(HttpStatus.OK).body(new StatusResponse("change state of recruiting successfully!"));
    }

    @GetMapping("/{user_id}")
    public ResponseEntity<?> readMyPostInfo( @PathVariable Long user_id) {
        User user = userRepository.findById(user_id).orElseThrow(IllegalAccessError::new);
        List<BoardPost> posts = boardPostRepository.findAllByUserId(user);


        List<PostDetailResponse> postInfo = new ArrayList<>();
        for (BoardPost post : posts) {
            postInfo.add(new PostDetailResponse(
                    post.getId(),
                    post.getUserId().getId(),
                    post.getUserId().getName(),
                    post.getTitle(),
                    post.getContent(),
                    post.getCreated_at(),
                    post.getSports(),
                    post.getLocation(),
                    post.getNumOfRecruits(),
                    post.getParticipants().size(),
                    post.isRecruiting()
            ));
        }


        PostsResponse response = new PostsResponse(postInfo);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @GetMapping("/participate/{user_id}")
    public ResponseEntity<?> readParticipatedPostInfo(@PathVariable Long user_id) {
        User user = userRepository.findById(user_id).orElseThrow(IllegalAccessError::new);
        List<BoardPost> posts = userPostRepository.getPostByUser(user);

        List<PostDetailResponse> postInfo = new ArrayList<>();
        for (BoardPost post : posts) {
            postInfo.add(new PostDetailResponse(
                    post.getId(),
                    post.getUserId().getId(),
                    post.getUserId().getName(),
                    post.getTitle(),
                    post.getContent(),
                    post.getCreated_at(),
                    post.getSports(),
                    post.getLocation(),
                    post.getNumOfRecruits(),
                    post.getParticipants().size(),
                    post.isRecruiting()
            ));
        }


        PostsResponse response = new PostsResponse(postInfo);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @GetMapping
    public ResponseEntity<?> getAllPost() {
        List<BoardPost> posts = boardPostRepository.findAll();

        List<PostDetailResponse> postInfo = new ArrayList<>();
        for (BoardPost post : posts) {
            postInfo.add(new PostDetailResponse(
                    post.getId(),
                    post.getUserId().getId(),
                    post.getUserId().getName(),
                    post.getTitle(),
                    post.getContent(),
                    post.getCreated_at(),
                    post.getSports(),
                    post.getLocation(),
                    post.getNumOfRecruits(),
                    post.getParticipants().size(),
                    post.isRecruiting()
            ));
        }


        PostsResponse response = new PostsResponse(postInfo);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

}
