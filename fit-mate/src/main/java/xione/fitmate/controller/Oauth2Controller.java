package xione.fitmate.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/oauth2")
public class Oauth2Controller {

    @GetMapping()
    public ResponseEntity<?> generateJwt() {
        // 현재 사용자 정보 가져오기
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        OidcUser oidcUser = (OidcUser) auth.getPrincipal();

        // 사용자 정보를 기반으로 JWT 생성
        String token = Jwts.builder()
                .setSubject(oidcUser.getName())
                .claim("authorities", oidcUser.getAuthorities().stream()
                        .map(GrantedAuthority::getAuthority)
                        .toArray(String[]::new))
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 3600000)) // 1시간 유효한 토큰
                .signWith(SignatureAlgorithm.HS256, "your-secret-key")
                .compact();

        return token;
    }
}
