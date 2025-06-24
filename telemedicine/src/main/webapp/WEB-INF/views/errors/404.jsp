<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 Not Found</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            overflow: hidden;
            font-family: Arial, sans-serif;
            color: white;
            text-align: center;
            background: #000;
        }

        .content {
            position: relative;
            z-index: 2;
            padding: 20px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }

        .travolta {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            opacity: 0.4;
            background: url('https://assets-9gag-fun.9cache.com/s/fab0aa49/033037194a549b0bf83e2ac4ba90706a52a9132e/static/dist/web6/img/404/bg.gif') center center no-repeat;
            background-size: cover;
            z-index: 1;
        }

        h1 {
            font-size: 8em;
            margin: 0;
            padding-top: 15vh;
        }

        p {
            font-size: 1.5em;
            margin: 20px 0;
        }

        a {
            color: #fff;
            text-decoration: none;
            border-bottom: 2px solid rgba(255, 255, 255, 0.3);
            transition: border-color 0.3s ease;
        }

        a:hover {
            border-color: rgba(255, 255, 255, 0.8);
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 4em;
                padding-top: 25vh;
            }
            
            p {
                font-size: 1.2em;
            }
        }
    </style>
</head>
<body>
    <div class="content">
        <h1><a href="/">404</a></h1>
        <p>There's nothing here.</p>
        <p><a href="/test">Go back to safety →</a></p>
    </div>
    <div class="travolta"></div>
</body>
</html>