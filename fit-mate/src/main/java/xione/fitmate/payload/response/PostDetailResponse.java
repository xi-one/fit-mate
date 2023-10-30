package xione.fitmate.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
public class PostDetailResponse {

    private Long id;
    private Long userId;
    private String title;
    private String content;
    private LocalDateTime dateTime;
    private String sports;
    private String location;
    private Integer numOfRecruits;
    private Integer  numOfParticipants;
    private boolean isRecruiting;
}
