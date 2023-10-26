package xione.fitmate.payload.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import xione.fitmate.domain.Sex;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
public class RegisterUserInfoRequest {
    private String region;
    private LocalDate birth;
    private Sex sex;
    private List<String> sports;
    private String nickname;

}
