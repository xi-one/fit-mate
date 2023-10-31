package xione.fitmate.web3;

import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.ECKeyPair;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.Contract;
import org.web3j.tx.RawTransactionManager;
import org.web3j.tx.TransactionManager;
import org.web3j.tx.gas.StaticGasProvider;
import xione.fitmate.web3.contract.FitToken;

import java.math.BigInteger;
@Log4j2
@Configuration
public class Web3jConfig {

    @Value("${alchemy.MUMBAI_API_URL}")
    private String ALCHEMY_API_URL;

    @Value("${metamask.PRIVATE_KEY}")
    private String PRIVATE_KEY;

    @Value("${metamask.CONTRACT_ADDRESS}")
    private String CONTRACT_ADDRESS;

    @Value("${web3.network.mumbai.chainId}")
    private long CHAIN_ID;

    @Bean
    public Web3j web3j() {
        return Web3j.build(new HttpService(ALCHEMY_API_URL));
    }


    @Bean
    public Credentials credentials() {
        log.info(PRIVATE_KEY);
        log.info("tessssssst1");
        BigInteger privateKeyInBT = new BigInteger(PRIVATE_KEY, 16);
        log.info("tessssssst");
        log.info(privateKeyInBT.toString());
        return Credentials.create(ECKeyPair.create(privateKeyInBT));
    }

    @Bean
    public TransactionManager web3TransactionManager() {
        return new RawTransactionManager(
                web3j(), credentials(), CHAIN_ID);
    }

    @Bean
    public FitToken fitToken() {
        BigInteger gasPrice = Contract.GAS_PRICE;
        BigInteger gasLimit = Contract.GAS_LIMIT;
        StaticGasProvider gasProvider = new StaticGasProvider(gasPrice, gasLimit);

        return FitToken.load(CONTRACT_ADDRESS, web3j(), web3TransactionManager(), gasProvider);
    }
}
