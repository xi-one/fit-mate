package xione.fitmate.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import xione.fitmate.domain.Sex;
import xione.fitmate.domain.User;
import xione.fitmate.repository.UserRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Log4j2
@Service
@RequiredArgsConstructor
public class UserInfoService {

    private final UserRepository userRepository;

    @Transactional
    public void register(Long id, String nickname, Sex sex, LocalDate birth, String region, List<String> sports) {
        log.info(sports);
        log.info(sports.getClass());
        Optional<User> userOptional = userRepository.findById(id);
        if(userOptional.isPresent()) {
            User user = userOptional.get();
            user.setName(nickname);
            user.setSports(sports);
            user.setSex(sex);
            user.setBirth(birth);
            user.setRegion(region);
            user.setCash(0L);
            userRepository.save(user);
        }


    }


}
