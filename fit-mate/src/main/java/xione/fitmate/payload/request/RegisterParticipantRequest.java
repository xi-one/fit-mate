package xione.fitmate.payload.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class RegisterParticipantRequest {
    private Long userId;
    private Long postId;
}
