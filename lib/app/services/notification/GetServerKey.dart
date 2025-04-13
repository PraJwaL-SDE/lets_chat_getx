import 'package:googleapis_auth/auth_io.dart';

class Getserverkey{
   static Future<String> getServerKeyToken() async{
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final clientCredentials = {
  "type": "service_account",
  "project_id": "chatting-app-2-8e7d4",
  "private_key_id": "ea3cdf8ed442aba8be5ae9ebba324b361a154dea",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC29s8jArEQMoYP\nf17n8V8uyYr1zCcSm3smyYnfws8kxnO3e+P6aBFlopwV5Asze5wOEkzelnRsYMER\nJssONOdgY004LfWUoMUaxSebyIDgk+qmbCBKXD3ILtzzGWt2vddgb8LULSxG2uVS\n20nxyJcH3KvKrfMJN9waDj3ShDHJPv66AuMRAsJsSdwMqwprH5ag+s10dsavoRlK\nX0jifdSocW9gzIHxpkn6be56qXwJx1UewnSGMINPUWoK/eEGfJUFU1pxSHweXpN5\n5d16hGloBlKPuYYnXbAsm/MZ4Js7T/xiUAA6D5LBzX81oiB0S52L5O/Ew/Ery+T8\nY3Vd1+pzAgMBAAECggEAGA6Bk7/h2hhaiiUcLHEPK86yJ7ltFcQ9wA7VwwcRR2uU\ngXaXtjACwZNM5I/0bRN+pFcBpm6v5iQenou0PSz1kzXbTFy2opE0+V0c5R3K3Dx2\nqOUkpcJVGUIYKRqZh6ZUcEihnFZIMRTM/ET7BwBx40W/jMmsX/TpSr++nzRke2pF\nFqgp/hJPulLMxBCGYDXwbhnrnFnSVaJmM5TrHJU1KWdiQyheo+KItxixFj4jCZst\n6jwdyVYF1FBrQmisPVKcGnlwozuJ3PnhmF9zjpVxK3HxR27Meq9Y1nA7Jt92q1Ck\nstrI4VqpOHclBkn3/qWeu/zCi3SvtBWlnbDm96FeWQKBgQDVRpVNTirgL/qU6f+r\nsc7/91q6GDrsdVeOYnIymDhzZj5XObtHoIkmPIT70mVRfJdGBzQa6kxhq6xVETHe\nu5MMI1kiReOETxz4oOOM34Yv0eHhO0eWLO4WE7YAZD2DQUYsFUwt13k5s9Kt4Ogy\n1ZOmdU4I/JU8rbadvQXxB9XNNwKBgQDbncFnWV5Ku2NMhEia6+3Y8Qjd6AAeGTq5\nC04+Ycpz7V1wbko+rS0LsFIrszFDXa1TO0PXBpSvdWkkdYklJB381VXHQaQYn1f8\n/2vIa23v4e0LTIpNGcinNIZ5+F/RKF/ovH9ULaj1SfsC1664NxOLu4wZ9rMNehd8\nU7NL0G2KpQKBgQCakYoZOcKXMg6QqDpUrAwStKk7X94siyqGldCf3HRlJj+eJcgW\nNEHRxWC3xRcLBJn59bSMoSv0SWAfUtPq0dTTojayQSaQOGoNw0THTyRIOftTqgvK\nygtPUr+/7uYp3z/FKTZJrvU7nZjdzbdbSDC3HiMNHknmbRuBnIHW2s/X5wKBgFO+\n2YRuiM1YnaoM+57P/tfuOiJcmMbhegocLI8PPWNtjWcVN4yk/vtpFjyBzXRR4YlO\nnTT+1m3+CMUVaOHX3vON6nLcLhYRlTztrY00oiyKa5kWa9qwzVotZmZWdztL+R7H\n2oogC0DWIDjaRE8M+ZAcSXWRJIAsIY6QYFu1tD/dAoGADXdG2iWI52WPpxfojD5t\nw3/ZZASE/5nlN0gRkrJiq/ble6wB2+Jt2CvmzXeXUQQTPqYC5WKREzwy0FPb69zG\nN9t5TgBSVA2xlZMQQsf7DFgYMgT9Cz19hU8B64SIpOCAhENzoFhLV7zXK0a/mGTz\n5rFB72kSO+hp38nGm6c/ysE=\n-----END PRIVATE KEY-----\n",
  "client_email": "chatting-app-2-8e7d4@appspot.gserviceaccount.com",
  "client_id": "102013216710225577477",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/chatting-app-2-8e7d4%40appspot.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
;

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
            clientCredentials)
        , scopes);
    return client.credentials.accessToken.data;
  }
}