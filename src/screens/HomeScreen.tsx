import React from 'react';
import { Pressable, SafeAreaView, ScrollView, StyleSheet, Text, View } from 'react-native';

import { EAppScreens, ScreenProps } from '../typescript';

interface TProps extends ScreenProps<EAppScreens.Home> {}

function Home({ navigation }: TProps): JSX.Element {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <ScrollView contentInsetAdjustmentBehavior="automatic" style={{}}>
        <Pressable
          onPress={() => {
            const book = {
              id: '1111',

              publication: {
                ebook: {
                  license:
                    '{"provider":"triggerdev.co.uk","id":"e87bd732-44f9-4af1-858c-b537ff5e1efa","issued":"2023-07-28T11:53:59Z","encryption":{"profile":"http://readium.org/lcp/basic-profile","content_key":{"algorithm":"http://www.w3.org/2001/04/xmlenc#aes256-cbc","encrypted_value":"xw0fhrSGTIUNW2h0rMCEStQ2bWmt1PkfLRHhWJain61X1ZJ7rGb/PjrFGOKvYUKsMmZYaI3mTFF6xJXf+5KF5A=="},"user_key":{"algorithm":"http://www.w3.org/2001/04/xmlenc#sha256","text_hint":"None","key_check":"I2wk9VY3ibTk6v6DdWPyIJFXGRn5JD+Hu8rhtIcQwieC03sbHeO977bsKMWNdt4lv3t0S0YXfZyZtVKTAneA7w=="}},"links":[{"rel":"status","href":"https://lcp.triggerdev.co.uk/licenses/e87bd732-44f9-4af1-858c-b537ff5e1efa/status","type":"application/vnd.readium.license.status.v1.0+json"},{"rel":"hint","href":"https://cdn.triggerdev.co.uk/pages/hint.html","type":"text/html"},{"rel":"publication","href":"https://cdn.triggerdev.co.uk/Pc9TS0qnkCdbycCtI_5DI-EBOOK","type":"application/epub+zip","title":"Pc9TS0qnkCdbycCtI_5DI-EBOOK","length":558351,"hash":"d53ac3bb6ca870754c2dbf69adb8cd39cc2bff9af7defc4925c6533857489d15"}],"user":{"id":"xuYYxAMX9q4ignpSLfT_B","email":"zVycO6z6HdPNAfhRY8YCI2I6ZzLtf7MAcs+A0GpN3N/N8oineHNMzRVkHzcxzIn2","encrypted":["email"]},"rights":{"print":10,"copy":5000,"start":"2023-07-28T11:53:59Z","end":"2028-07-26T11:53:59Z"},"signature":{"certificate":"MIIFpTCCA42gAwIBAgIBATANBgkqhkiG9w0BAQsFADBnMQswCQYDVQQGEwJGUjEOMAwGA1UEBxMFUGFyaXMxDzANBgNVBAoTBkVEUkxhYjESMBAGA1UECxMJTENQIFRlc3RzMSMwIQYDVQQDExpFRFJMYWIgUmVhZGl1bSBMQ1AgdGVzdCBDQTAeFw0xNjAzMjUwMzM3MDBaFw0yNjAzMjMwNzM3MDBaMIGQMQswCQYDVQQGEwJGUjEOMAwGA1UEBxMFUGFyaXMxDzANBgNVBAoTBkVEUkxhYjESMBAGA1UECxMJTENQIFRlc3RzMSIwIAYDVQQDExlUZXN0IHByb3ZpZGVyIGNlcnRpZmljYXRlMSgwJgYJKoZIhvcNAQkBFhlsYXVyZW50LmxlbWV1ckBlZHJsYWIub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAq/gFXdvKb+EOzsEkHcoSOcPQmNzivzf+9NOJcxWi1/BwuxqAAPv+4LKoLz89U1xx5TE1swL11BsEkIdVYrjl1RiYRa8YV4bb4xyMTm8lm39P16H1fG7Ep8yyoVuN6LT3WT2xHGp2jYU8I2nW78cyYApAWAuiMc3epeIOxC2mKgf1pGnaX9j5l/Rx8hhxULqoHIHpR8e1eVRC7tgAz4Oy5qeLxGoL4S+GK/11eRlDO37whAWaMRbPnJDqqi8Z0Beovf6jmdoUTJdcPZZ9kFdtPsWjPNNHDldPuJBtCd7lupc0K4pClJSqtJKyxs05Yeb1j7kbs/i3grdlUcxz0zOaPN1YzrzOO7GLEWUnIe+LwVXAeUseHedOexITyDQXXCqMoQw/BC6ApGzR0FynC6ojq98tStYGJAGbKBN/9p20CvYf4/hmPU3fFkImWguPIoeJT//0rz+nSynykeEVtORRIcdyOnX2rL03xxBW7qlTlUXOfQk5oLIWXBW9Z2Q63MPWi8jQhSI0jC12iEqCT54xKRHNWKr04at9pJL85M0bDCbBH/jJ+AIbVx02ewtXcWgWTgK9vgSPN5kRCwIGaV9PMS193KHfNpGqV45EKrfP8U2nvNDeyqLqAN5847ABSW7UmA5Kj/x5uGxIWu9MUKjZlT0FpepswFvMMo1InLHANMcCAwEAAaMyMDAwDAYDVR0TAQH/BAIwADALBgNVHQ8EBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwEwDQYJKoZIhvcNAQELBQADggIBAEGAqzHsCbrfQwlWas3q66FG/xbiOYQxpngA4CZWKQzJJDyOFgWEihW+H6NlSIH8076srpIZByjEGXZfOku4NH4DGNOj6jQ9mEfEwbrvCoEVHQf5YXladXpKqZgEB2FKeJVjC7yplelBtjBpSo23zhG/o3/Bj7zRySL6gUCewn7z/DkxM6AshDE4HKQxjxp7stpESev+0VTL813WXvwzmucr94H1VPrasFyVzQHj4Ib+Id1OAmgfzst0vSZyX6bjAuiN9yrs7wze5cAYTaswWr7GAnAZ/r1Z3PiDp50qaGRhHqJ+lRAhihpFP+ZjsYWRqnxZnDzJkJ6RZAHi2a3VN8x5WhOUMTf3JZcFVheDmA4SaEjAZAHU8zUxx1Fstjc8GJcjTwWxCsVM2aREBKXAYDhPTVLRKt6PyQxB0GxjDZZSvGI9uXn6S5wvjuE4T2TUwbJeGHqJr4FNpXVQ2XNww+sV2QSiAwrlORm8HNXqavj4rqz1PkUySXJ6b7zbjZoiACq4C7zb70tRYDyCfLTYtaTL3UK2Sa9ePSl0Fe6QfcqlGjalrqOo4GI6oqbAIkIXocHHksbLx0mIMSEWQOax+DqXhsl8tNGVwa5EiUSy83Sc0LyYXoWA35q8dugbkeNnY94rNG/hYKeci1VHhyg4rqxEeVwfBx121JqQSs+hHGKt","value":"miHEJsnQSVU50aRMZX6f1uF4f6Bwqf9vmKwamXrvfqFmwy4CjkcmsQWVJAezfmp6ojDa0ra1E9EY9vd/hyN9uY6Nm/DlZACIu4gLu+xZ5Sk8syrK3G34WVPNhzyR1n1zPuSR86EI3u4+FClBVfq19sYQlwPsgZIQOWfvxZeK+I0UrGwQSrXampX4YFEdN9DQ/VsjlPWfUzgk2GaVNBVyd4LJzlAaXBzVqiZQyTBFkVTfHQLm4yQ396bQ8EXj0/KSJft5gKBJ7zM+yJK4VSN8CHFgqijJELSBisJ+pIfQ6pdEiTrlWh9PCrvC3XLHvXnheFeyue6OgLXi9gt5tTufbQizI9TzCUIGZ4u/edvFr8AszOstlz4viROYkJf+2owVjqc0K4nRKZ8T7wuPoIH0sX7dFiskp47qPVGF+iUmb0GaOBtef5MrFAxe5r++DNMCVj/uEJDNE2ofnKBA5z+j8SUDU/aXe/C2txDoc6ZVCOD+ZOGcTgVTj+Quetd7S/lR/ZkAy3cMxm4FmcOUOXDojH/I9W4ReM3ckL8WruwwLQfvCsxzGW7nwSvl8QBHbzVF/lrXg31ds0XZJ0YPTy6MZc8nmsYCECMs16eXVK0zSQi5G4Aa6Uk3aHkd4fOwPQyvpQWuhQhyUbgjUFuqj4lNKeHPjkAuD0w/njWl6ZFLlvQ=","algorithm":"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"}}',
                  passphrase: 'D7g1FhBKniLMP8q9QWoyw',
                  progress: 0,
                },
              },
              title: 'Normal book',
            };

            navigation.navigate(EAppScreens.Book, { book });
          }}
        >
          <View style={styles.buttonStyle}>
            <Text style={styles.buttonTextStyle}>Normal book</Text>
          </View>
        </Pressable>
        <Pressable
          onPress={() => {
            const book = {
              id: '2222',
              publication: {
                ebook: {
                  license:
                    '{"provider":"triggerdev.co.uk","id":"d5beb770-6385-43b1-922e-0324847617fd","issued":"2023-09-11T07:22:53Z","encryption":{"profile":"http://readium.org/lcp/basic-profile","content_key":{"algorithm":"http://www.w3.org/2001/04/xmlenc#aes256-cbc","encrypted_value":"bl3BzavPVr8zD5Va3X0Z5N8mIgeOwnYZx4n/ENPq0TvxDOsKQx+lZOnoBybOnIMz0+cQE3mFwD4tj4m8nqrocA=="},"user_key":{"algorithm":"http://www.w3.org/2001/04/xmlenc#sha256","text_hint":"None","key_check":"FMkInp8CyIgEKuu7Fp/Z4ardiLl/smGpUzUS4jqVz9DcCvPCdBbjEV/DoH8jg5nbN8GPG5wPMiNtNqKCpOyeOw=="}},"links":[{"rel":"publication","href":"https://cdn.triggerdev.co.uk/ZeJ9sTa5PvqRhzC-grnCn-EBOOK","type":"application/epub+zip","title":"ZeJ9sTa5PvqRhzC-grnCn-EBOOK","length":18658571,"hash":"f6603306802ad2d29ce1fe52e12a28d635eb9532fbd475394b746cf9f04feb44"},{"rel":"status","href":"https://lcp.triggerdev.co.uk/licenses/d5beb770-6385-43b1-922e-0324847617fd/status","type":"application/vnd.readium.license.status.v1.0+json"},{"rel":"hint","href":"https://cdn.triggerdev.co.uk/pages/hint.html","type":"text/html"}],"user":{"id":"xuYYxAMX9q4ignpSLfT_B","email":"GGFBrn0qyUvtMnWtwIQ2XV69AtJvpghd4jKxAYAMfPGcZUq/bvb5p5UW/ckarsB1","encrypted":["email"]},"rights":{"print":10,"copy":5000,"start":"2023-09-11T07:22:53Z","end":"2028-09-09T07:22:53Z"},"signature":{"certificate":"MIIFpTCCA42gAwIBAgIBATANBgkqhkiG9w0BAQsFADBnMQswCQYDVQQGEwJGUjEOMAwGA1UEBxMFUGFyaXMxDzANBgNVBAoTBkVEUkxhYjESMBAGA1UECxMJTENQIFRlc3RzMSMwIQYDVQQDExpFRFJMYWIgUmVhZGl1bSBMQ1AgdGVzdCBDQTAeFw0xNjAzMjUwMzM3MDBaFw0yNjAzMjMwNzM3MDBaMIGQMQswCQYDVQQGEwJGUjEOMAwGA1UEBxMFUGFyaXMxDzANBgNVBAoTBkVEUkxhYjESMBAGA1UECxMJTENQIFRlc3RzMSIwIAYDVQQDExlUZXN0IHByb3ZpZGVyIGNlcnRpZmljYXRlMSgwJgYJKoZIhvcNAQkBFhlsYXVyZW50LmxlbWV1ckBlZHJsYWIub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAq/gFXdvKb+EOzsEkHcoSOcPQmNzivzf+9NOJcxWi1/BwuxqAAPv+4LKoLz89U1xx5TE1swL11BsEkIdVYrjl1RiYRa8YV4bb4xyMTm8lm39P16H1fG7Ep8yyoVuN6LT3WT2xHGp2jYU8I2nW78cyYApAWAuiMc3epeIOxC2mKgf1pGnaX9j5l/Rx8hhxULqoHIHpR8e1eVRC7tgAz4Oy5qeLxGoL4S+GK/11eRlDO37whAWaMRbPnJDqqi8Z0Beovf6jmdoUTJdcPZZ9kFdtPsWjPNNHDldPuJBtCd7lupc0K4pClJSqtJKyxs05Yeb1j7kbs/i3grdlUcxz0zOaPN1YzrzOO7GLEWUnIe+LwVXAeUseHedOexITyDQXXCqMoQw/BC6ApGzR0FynC6ojq98tStYGJAGbKBN/9p20CvYf4/hmPU3fFkImWguPIoeJT//0rz+nSynykeEVtORRIcdyOnX2rL03xxBW7qlTlUXOfQk5oLIWXBW9Z2Q63MPWi8jQhSI0jC12iEqCT54xKRHNWKr04at9pJL85M0bDCbBH/jJ+AIbVx02ewtXcWgWTgK9vgSPN5kRCwIGaV9PMS193KHfNpGqV45EKrfP8U2nvNDeyqLqAN5847ABSW7UmA5Kj/x5uGxIWu9MUKjZlT0FpepswFvMMo1InLHANMcCAwEAAaMyMDAwDAYDVR0TAQH/BAIwADALBgNVHQ8EBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwEwDQYJKoZIhvcNAQELBQADggIBAEGAqzHsCbrfQwlWas3q66FG/xbiOYQxpngA4CZWKQzJJDyOFgWEihW+H6NlSIH8076srpIZByjEGXZfOku4NH4DGNOj6jQ9mEfEwbrvCoEVHQf5YXladXpKqZgEB2FKeJVjC7yplelBtjBpSo23zhG/o3/Bj7zRySL6gUCewn7z/DkxM6AshDE4HKQxjxp7stpESev+0VTL813WXvwzmucr94H1VPrasFyVzQHj4Ib+Id1OAmgfzst0vSZyX6bjAuiN9yrs7wze5cAYTaswWr7GAnAZ/r1Z3PiDp50qaGRhHqJ+lRAhihpFP+ZjsYWRqnxZnDzJkJ6RZAHi2a3VN8x5WhOUMTf3JZcFVheDmA4SaEjAZAHU8zUxx1Fstjc8GJcjTwWxCsVM2aREBKXAYDhPTVLRKt6PyQxB0GxjDZZSvGI9uXn6S5wvjuE4T2TUwbJeGHqJr4FNpXVQ2XNww+sV2QSiAwrlORm8HNXqavj4rqz1PkUySXJ6b7zbjZoiACq4C7zb70tRYDyCfLTYtaTL3UK2Sa9ePSl0Fe6QfcqlGjalrqOo4GI6oqbAIkIXocHHksbLx0mIMSEWQOax+DqXhsl8tNGVwa5EiUSy83Sc0LyYXoWA35q8dugbkeNnY94rNG/hYKeci1VHhyg4rqxEeVwfBx121JqQSs+hHGKt","value":"ozWEexV6gvLh8Opl5tnX0z9IgoOLLdeRg/cbuGp1M7H1NRUpDMm36tubpVA3wv1+n1CcncpSKeRi7bUpy0LkRV2eRv2KlUxaVTCFA899EpPYiC3hrI/V2vj57nPvW4AOAAzTakxnHgf7spScCxy0qAgStXmXJgjlujeb81K/oInWsMzTQsUIrzLn1Wa+Req6jcV9mK3Tzx9FnXgy6kQR+Vsj46aOzz/9wJo1/eVEJJT0bLv65ntjLYSZvuYzXYXIM19BzUANZA3m9HsaTgwQ/2xN4DKBwcztydPB9UNFFRsQA+Xp61lgZ7dDY1bVKBP/q0tgpW3tSQ/MQJfw/Jerz/lzosIVfFhoEdnG8Shx+Y7gVUsaLcoJV1PLxE0sAjjAFfjr2f2fFGQZJ04X121VkosirCNbwQA9jQPw8+OcZDgU3jHXvMPBUAWCZQ6fYd48tvJzqbAR2HHV4gJwlI10WK9e+P6vl6Dd4ElMU2TrPXjS2iNCLkM6MvDtpnRaceHG3Mhm1lUy1fGMqly8XWy/bm4nkRlnRm3+ZShdKn90KCDwRpn0bNuQewKeIW6yyYl6/SkK02w5lz5lGsE6VPQ/R9iByrmE7W7BmtICaTuRdWJZbI61p1KJy5t5TZtzONIOkJfBeQsODHLGtL4Jg+7i2CrAKxqCpK3hHdC9dT4AFuo=","algorithm":"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"}}',
                  passphrase: 'WDgsdfuqWnelTBd87ebGs',
                  progress: 0,
                },
              },
              title: 'Fixed book',
            };
            navigation.navigate(EAppScreens.Book, { book });
          }}
        >
          <View style={styles.buttonStyle}>
            <Text style={styles.buttonTextStyle}>Fixed book</Text>
          </View>
        </Pressable>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  buttonStyle: {
    height: 50,
    backgroundColor: 'tomato',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 12,
    margin: 10,
  },
  buttonTextStyle: {
    color: 'white',
    fontSize: 24,
    fontWeight: 'bold',
  },
});

export default Home;
