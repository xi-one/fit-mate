package xione.fitmate.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import xione.fitmate.domain.BoardPost;
import xione.fitmate.domain.TokenHistory;
import xione.fitmate.domain.User;
import xione.fitmate.domain.UserPost;
import xione.fitmate.payload.request.RegisterPostRequest;
import xione.fitmate.payload.request.RewardTokenRequest;
import xione.fitmate.payload.request.WithdrawRequest;
import xione.fitmate.payload.response.*;
import xione.fitmate.repository.BoardPostRepository;
import xione.fitmate.repository.TokenHistoryRepository;
import xione.fitmate.repository.UserPostRepository;
import xione.fitmate.repository.UserRepository;
import xione.fitmate.security.oauth2.CustomUserDetails;
import xione.fitmate.web3.Web3jService;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Log4j2
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/reward")
@RequiredArgsConstructor
public class RewardController {
    final UserRepository userRepository;
    final UserPostRepository userPostRepository;
    final BoardPostRepository boardPostRepository;
    final TokenHistoryRepository tokenHistoryRepository;
    final Web3jService web3jService;

    @PostMapping
    public ResponseEntity<?> rewardToken(@Valid @RequestBody RewardTokenRequest rewardRequest) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = Long.valueOf(userDetails.getName());

        if(!userId.equals(rewardRequest.getUserId())) {
            throw new IllegalArgumentException("user Id is different");
        }
        User user = userRepository.findById(rewardRequest.getReceiverUserId()).orElseThrow(IllegalAccessError::new);
        BoardPost post = boardPostRepository.findById(rewardRequest.getPostId()).orElseThrow(IllegalAccessError::new);
        UserPost userPost = userPostRepository.findByUserAndPost(user, post);
        if(!Objects.equals(post.getUserId().getId(), rewardRequest.getUserId())) {
            return ResponseEntity.status(HttpStatus.ACCEPTED).body(new StatusResponse("userId of request is different from userId of the post"));
        }

        if(userPost.getIsRewarded()) {
            return ResponseEntity.status(HttpStatus.ACCEPTED).body(new StatusResponse("already rewarded"));
        }
        userPost.setIsRewarded(true);
        userPostRepository.save(userPost);
        user.setCash(user.getCash() + 10);
        userRepository.save(user);

        TokenHistory tokenHistory = new TokenHistory(
                10L,
                "핏메이트와 운동",
                user
        );

        tokenHistoryRepository.save(tokenHistory);


        return ResponseEntity.status(HttpStatus.OK).body(new StatusResponse("rewarded successfully!"));
    }

    @PostMapping("/withdraw")
    public ResponseEntity<?> withdrawToken(@Valid @RequestBody WithdrawRequest withdrawRequest) throws Exception {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = Long.valueOf(userDetails.getName());

        if(!userId.equals(withdrawRequest.getUserId())) {
            throw new IllegalArgumentException("user Id is different");
        }


        User user = userRepository.findById(withdrawRequest.getUserId()).orElseThrow(IllegalAccessError::new);
        Long amount = user.getCash();
        if(amount <= 0) {
            return ResponseEntity.status(HttpStatus.ACCEPTED).body(new StatusResponse("balance is lower than 0"));
        }
        String address = withdrawRequest.getAddress();
        TransactionReceipt receipt = web3jService.mint(address, amount);
        log.info(receipt);
        user.setCash(0L);
        userRepository.save(user);
        TokenHistory tokenHistory = new TokenHistory(
                (-amount),
                "출금",
                user
        );

        tokenHistoryRepository.save(tokenHistory);

        return ResponseEntity.status(HttpStatus.OK).body(new withdrawResponse("withdrawn successfully!", receipt.getTransactionHash()));

    }

    @GetMapping("/{user_id}")
    public ResponseEntity<?> readTokenHistory( @PathVariable Long user_id) {
        User user = userRepository.findById(user_id).orElseThrow(IllegalAccessError::new);
        List<TokenHistory> tokenHistoryList = tokenHistoryRepository.findAllByUser(user);


        List<History> HistoryList = new ArrayList<>();
        for (TokenHistory history : tokenHistoryList) {
            HistoryList.add(new History(
                    history.getId(),
                    history.getUser().getId(),
                    history.getContent(),
                    history.getCreated_at(),
                    history.getAmount()
            ));
        }


        TokenHistoryResponse response = new TokenHistoryResponse(HistoryList);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }



}
