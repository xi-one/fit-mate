package xione.fitmate.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
public class History {
    private Long id;
    private Long userId;
    private String content;
    private LocalDateTime dateTime;

}
