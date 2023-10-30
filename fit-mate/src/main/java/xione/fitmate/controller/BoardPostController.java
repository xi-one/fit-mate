package xione.fitmate.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import xione.fitmate.domain.BoardPost;
import xione.fitmate.domain.Sex;
import xione.fitmate.domain.User;
import xione.fitmate.payload.request.RegisterPostRequest;
import xione.fitmate.payload.request.RegisterUserInfoRequest;
import xione.fitmate.payload.request.SetRecruitingRequest;
import xione.fitmate.payload.response.AllPostsResponse;
import xione.fitmate.payload.response.PostDetailResponse;
import xione.fitmate.payload.response.StatusResponse;
import xione.fitmate.payload.response.UserInfoResponse;
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
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardPostController {

    private final UserRepository userRepository;
    private final BoardPostRepository boardPostRepository;


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
        post.setParticipants(new ArrayList<>());


        boardPostRepository.save(post);


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

    @GetMapping("/{post_id}")
    public ResponseEntity<?> readPostInfo( @PathVariable Long post_id) {
        BoardPost post = boardPostRepository.findById(post_id).orElseThrow(IllegalAccessError::new);


        PostDetailResponse response = new PostDetailResponse(
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
        );
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @GetMapping
    public ResponseEntity<?> getAllPost() {
        List<BoardPost> posts = boardPostRepository.findAll();

        List<PostDetailResponse> postInfo = new ArrayList<>();
        for(int i = 0; i < posts.size(); i++) {
            BoardPost post = posts.get(i);
            postInfo.add( new PostDetailResponse(
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


        AllPostsResponse response = new AllPostsResponse(postInfo);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

}
