package xione.fitmate.payload.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class RewardTokenRequest {
    private Long userId;
    private Long receiverUserId;
    private Long postId;
}
