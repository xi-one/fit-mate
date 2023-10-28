package xione.fitmate.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
@Getter
@Setter
@AllArgsConstructor
public class Comment {
    private Long id;
    private String contents;
    private LocalDateTime datetime;
    private Long postId;
    private String userName;
    private Long userId;
}
