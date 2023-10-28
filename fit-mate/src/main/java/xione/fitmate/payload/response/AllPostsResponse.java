package xione.fitmate.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
public class AllPostsResponse {

    List<PostDetailResponse> posts;
}
