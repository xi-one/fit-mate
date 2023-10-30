package xione.fitmate.payload.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class SetRecruitingRequest {
    private Long userId;
    private Long postId;
    private boolean isRecruiting;
}
