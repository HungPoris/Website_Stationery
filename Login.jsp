<%-- 
    Document   : login.jsp
    Created on : Feb 5, 2025, 11:14:45 AM
    Author     : HungTQ
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login Page</title>
    <link rel="stylesheet" href="https://cdn.lineicons.com/4.0/lineicons.css" />
    <link rel="stylesheet" href="Layout/Css/style.css" />
    <script src="https://accounts.google.com/gsi/client" async></script>
</head>
<body>
    <video id="background-video" autoplay loop muted>
        <source src="Image/964df1d1e8c1bc21f634c7e268a2748e.mp4" type="video/mp4" />
    </video>
    <div id="mute-btn" onclick="toggleMute()" class="lni lni-volume-mute"></div>

    <div class="container" id="container">
        <div class="form-container register-container">
            <form action="register" method="post">
                <h1>Register here</h1>
                <input type="text" name="name" placeholder="Name" />
                <input type="email" name="email" placeholder="Email" />
                <input type="password" name="password" placeholder="Password" />
                <button type="submit">Register</button>
                <span>or use your account</span>
                <div class="social-container">
                    <div id="g_id_signup"></div>
                </div>
            </form>
        </div>

        <div class="form-container login-container">
            <form action="login" method="post">
                <h1>Login here</h1>
                <input type="email" name="email" placeholder="Email" />
                <input type="password" name="password" placeholder="Password" />
                <div class="content">
                    <div class="checkbox">
                        <input type="checkbox" name="remember" id="checkbox" />
                        <label for="checkbox">Remember me</label>
                    </div>
                    <div class="pass-link">
                        <a href="#">Forgot password?</a>
                    </div>
                </div>
                <button type="submit">Login</button>
                <span>or use your account</span>
                <div class="social-container">
                    <div id="g_id_signin"></div>
                </div>
            </form>
        </div>

        <div class="overlay-container">
            <div class="overlay">
                <div class="overlay-panel overlay-left">
                    <h1 class="title">Hello <br />friends</h1>
                    <p>If you have an account, login here and have fun.</p>
                    <button class="ghost" id="login">Login</button>
                </div>

                <div class="overlay-panel overlay-right">
                    <h1 class="title">Start your <br />journey now</h1>
                    <p>If you don't have an account yet, join us and start your journey.</p>
                    <button class="ghost" id="register">Register</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Panel switching
        document.getElementById("register").addEventListener("click", function() {
            document.getElementById("container").classList.add("right-panel-active");
        });

        document.getElementById("login").addEventListener("click", function() {
            document.getElementById("container").classList.remove("right-panel-active");
        });

        // Video mute toggle
        function toggleMute() {
            var video = document.getElementById("background-video");
            var muteBtn = document.getElementById("mute-btn");
            if (video.muted) {
                video.muted = false;
                muteBtn.className = "lni lni-volume";
            } else {
                video.muted = true;
                muteBtn.className = "lni lni-volume-mute";
            }
        }

        // Google Sign In configuration
        function handleCredentialResponse(response) {
            const responsePayload = decodeJwtResponse(response.credential);
            
            // Send to server for verification
            fetch('google-auth', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    credential: response.credential,
                    userData: {
                        id: responsePayload.sub,
                        email: responsePayload.email,
                        name: responsePayload.name,
                        picture: responsePayload.picture
                    }
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.location.href = 'dashboard';
                } else {
                    alert(data.message || 'Login failed!');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred during login.');
            });
        }

        function decodeJwtResponse(token) {
            const base64Url = token.split(".")[1];
            const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
            const jsonPayload = decodeURIComponent(
                atob(base64)
                    .split("")
                    .map((c) => "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2))
                    .join("")
            );
            return JSON.parse(jsonPayload);
        }

        window.onload = function() {
            google.accounts.id.initialize({
                client_id: '<%=application.getInitParameter("googleClientId")%>',
                callback: handleCredentialResponse,
                auto_select: false,
                cancel_on_tap_outside: true
            });
            
            // Render sign-in button
            google.accounts.id.renderButton(
                document.getElementById("g_id_signin"),
                {
                    theme: "outline",
                    size: "large",
                    width: 250,
                    text: "signin_with"
                }
            );
            
            // Render sign-up button
            google.accounts.id.renderButton(
                document.getElementById("g_id_signup"),
                {
                    theme: "outline",
                    size: "large",
                    width: 250,
                    text: "signup_with"
                }
            );
        };
    </script>
</body>
</html>