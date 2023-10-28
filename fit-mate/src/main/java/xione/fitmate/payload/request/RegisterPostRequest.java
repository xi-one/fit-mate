package xione.fitmate.payload.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import xione.fitmate.domain.User;



@Getter
@Setter
@AllArgsConstructor
public class RegisterPostRequest {

    private Long userId;
    private String title;
    private String content;
    private String sports;
    private String location;
    private Integer numOfRecruits;

}
