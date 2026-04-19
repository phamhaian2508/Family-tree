package com.javaweb.config;

import com.javaweb.security.CustomSuccessHandler;
import com.javaweb.security.CustomAuthenticationFailureHandler;
import com.javaweb.security.CustomLogoutSuccessHandler;
import com.javaweb.service.impl.CustomUserDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.header.writers.ReferrerPolicyHeaderWriter;
import org.springframework.security.web.header.writers.StaticHeadersWriter;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private CustomSuccessHandler customSuccessHandler;

    @Autowired
    private CustomAuthenticationFailureHandler customAuthenticationFailureHandler;

    @Autowired
    private CustomLogoutSuccessHandler customLogoutSuccessHandler;

    @Bean
    public UserDetailsService userDetailsService() {
        return new CustomUserDetailService();
    }
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService());
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }
    @Override
    protected void configure(AuthenticationManagerBuilder auth) {
        auth.authenticationProvider(authenticationProvider());
    }
    @Override
    protected void configure(HttpSecurity http) throws Exception {
                http
                        .csrf()
                        .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                        .and()
                        .headers()
                        .contentTypeOptions()
                        .and()
                        .frameOptions().sameOrigin()
                        .addHeaderWriter(new ReferrerPolicyHeaderWriter(ReferrerPolicyHeaderWriter.ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN))
                        .addHeaderWriter(new StaticHeadersWriter("Content-Security-Policy",
                                "default-src 'self'; "
                                        + "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://ajax.googleapis.com https://code.jquery.com https://cdnjs.cloudflare.com; "
                                        + "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://ajax.googleapis.com https://code.jquery.com https://cdnjs.cloudflare.com; "
                                        + "img-src 'self' data: blob: https:; "
                                        + "media-src 'self' blob: https:; "
                                        + "font-src 'self' data: https://cdnjs.cloudflare.com; "
                                        + "connect-src 'self' ws: wss:; "
                                        + "frame-ancestors 'self'; object-src 'none'; base-uri 'self';"))
                        .and()
                        .authorizeRequests()

                        .antMatchers
                                (
                                         "/admin/user-edit/**", "/admin/user-edit-*", "/admin/user-list"
                                )
                        .hasRole("MANAGER")
                        .antMatchers(
                                "/admin/assets/**",
                                "/admin/js/**",
                                "/admin/css/**",
                                "/admin/font/**",
                                "/admin/font-awesome/**",
                                "/admin/paging/**",
                                "/admin/sweetalert/**"
                        ).permitAll()
                        .antMatchers("/admin/home").hasAnyRole("MANAGER","EDITOR","USER")
                        .antMatchers("/admin/family-trees", "/admin/family-trees/**").hasAnyRole("MANAGER","EDITOR","USER")
                        .antMatchers("/admin/familytree", "/admin/familytree/**").hasAnyRole("MANAGER","EDITOR","USER")
                        .antMatchers("/admin/family-content", "/admin/family-content/**").hasAnyRole("MANAGER","EDITOR","USER")
                        .antMatchers("/admin/livestream", "/admin/livestream/**").hasAnyRole("MANAGER","EDITOR","USER")
                        .antMatchers("/admin/media", "/admin/media/**").hasAnyRole("MANAGER","EDITOR","USER")
                        .antMatchers("/admin/profile-*", "/admin/profile-password").hasAnyRole("MANAGER","EDITOR","USER")
                        .antMatchers("/admin/security-audit").hasRole("MANAGER")
                        .antMatchers("/admin/**").hasAnyRole("MANAGER","EDITOR")
                        .antMatchers(HttpMethod.POST, "/api/person/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.PUT, "/api/person/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.DELETE, "/api/person/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.GET, "/api/person/**").hasAnyRole("MANAGER", "EDITOR", "USER")
                        .antMatchers(HttpMethod.POST, "/api/branch/**").hasRole("MANAGER")
                        .antMatchers(HttpMethod.GET, "/api/branch/**").hasAnyRole("MANAGER", "EDITOR", "USER")
                        .antMatchers(HttpMethod.POST, "/api/family-trees/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.PUT, "/api/family-trees/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.DELETE, "/api/family-trees/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.GET, "/api/family-trees/**").hasAnyRole("MANAGER", "EDITOR", "USER")
                        .antMatchers(HttpMethod.POST, "/api/family-content/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.PUT, "/api/family-content/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.DELETE, "/api/family-content/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.GET, "/api/family-content/**").hasAnyRole("MANAGER", "EDITOR", "USER")
                        .antMatchers(HttpMethod.POST, "/api/user").hasRole("MANAGER")
                        .antMatchers(HttpMethod.PUT, "/api/user/*").hasRole("MANAGER")
                        .antMatchers(HttpMethod.PUT, "/api/user/password/*/reset").hasRole("MANAGER")
                        .antMatchers(HttpMethod.DELETE, "/api/user/**").hasRole("MANAGER")
                        .antMatchers(HttpMethod.PUT, "/api/user/change-password/**").authenticated()
                        .antMatchers(HttpMethod.PUT, "/api/user/profile/**").authenticated()
                        .antMatchers(HttpMethod.POST, "/api/media/upload").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.POST, "/api/media/albums").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.DELETE, "/api/media/albums/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.DELETE, "/api/media/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.GET, "/api/media/**").hasAnyRole("MANAGER", "EDITOR", "USER")
                        .antMatchers("/api/livestream/**").authenticated()
                        .antMatchers("/api/**").authenticated()
                        .antMatchers("/watch").authenticated()
                        .antMatchers("/ws/**").authenticated()
                        .antMatchers("/login", "/dang-ky", "/register", "/resource/**", "/trang-chu").permitAll()
                        .and()
                        .formLogin().loginPage("/login").usernameParameter("j_username").passwordParameter("j_password").permitAll()
                        .loginProcessingUrl("/j_spring_security_check")
                        .successHandler(customSuccessHandler)
                        .failureHandler(customAuthenticationFailureHandler).and()
                        .logout().logoutUrl("/logout").logoutSuccessHandler(customLogoutSuccessHandler).deleteCookies("JSESSIONID")
                        .and().exceptionHandling().accessDeniedPage("/access-denied").and()
                        .sessionManagement().maximumSessions(1).expiredUrl("/login?sessionTimeout");
    }
}
