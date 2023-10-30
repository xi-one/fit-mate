package xione.fitmate.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class Participant {
    private Long userId;
    private String name;
    private String img;
}
