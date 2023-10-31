package xione.fitmate.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserPost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "post_id")
    private BoardPost post;

    @Column(nullable = false)
    private Boolean isRewarded;

    public UserPost(User user, BoardPost post) {
        this.user = user;
        this.post = post;
        this.isRewarded = false;
    }
}
