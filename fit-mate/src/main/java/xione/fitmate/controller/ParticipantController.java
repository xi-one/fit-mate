package xione.fitmate.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import xione.fitmate.domain.BoardComment;
import xione.fitmate.domain.BoardPost;
import xione.fitmate.domain.User;
import xione.fitmate.domain.UserPost;
import xione.fitmate.payload.request.RegisterParticipantRequest;
import xione.fitmate.payload.request.RegisterPostRequest;
import xione.fitmate.payload.response.*;
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
@RequestMapping("/participant")
@RequiredArgsConstructor
public class ParticipantController {

    final UserRepository userRepository;
    final BoardPostRepository boardPostRepository;
    final UserPostRepository userPostRepository;

    @PostMapping
    public ResponseEntity<?> registerParticipant(@Valid @RequestBody RegisterParticipantRequest participantRequest) throws Exception {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = Long.valueOf(userDetails.getName());

        if(!userId.equals(participantRequest.getUserId())) {
            throw new IllegalArgumentException("user Id is different");
        }
        User user = userRepository.findById(participantRequest.getUserId()).orElseThrow(IllegalAccessError::new);
        BoardPost post = boardPostRepository.findById(participantRequest.getPostId())
                .orElseThrow(IllegalAccessError::new);
        if(!post.isRecruiting()) {
            return ResponseEntity.status(HttpStatus.ACCEPTED).body(new StatusResponse("recruit ended"));
        }

        if(post.getNumOfRecruits() <= post.getParticipants().size()) {
            return ResponseEntity.status(HttpStatus.ACCEPTED).body(new StatusResponse("num of recruits is full"));
        }
        if(userPostRepository.existsByUserAndPost(user, post)) {
            return ResponseEntity.status(HttpStatus.ACCEPTED).body(new StatusResponse("duplicated"));
        }


        UserPost userPost = new UserPost(user, post);
        userPostRepository.save(userPost);


        return ResponseEntity.status(HttpStatus.CREATED).body(new StatusResponse("participant registered successfully!"));
    }

    @GetMapping("/{post_id}")
    public ResponseEntity<?> readParticipants( @PathVariable Long post_id) {
        BoardPost post = boardPostRepository.findById(post_id).orElseThrow(IllegalAccessError::new);
        List<UserPost> userPostList = userPostRepository.findAllByPost(post);

        List<Participant> participants = new ArrayList<>();
        for (UserPost userPost : userPostList) {
            User user = userPost.getUser();
            participants.add(new Participant(user.getId(), user.getName(), user.getImg()));
        }

        ParticipantsResponse response = new ParticipantsResponse(
                post_id,
                participants
        );

        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

}


