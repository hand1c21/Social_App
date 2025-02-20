import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('תנאי השימוש'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "תנאי שימוש באפליקציה\n\n"
            "כללי\n\n"
            "אפליקציה זו הינה בבעלות החברה והיא מיועדת על ידה ו/או עבורה.\n"
            "תנאי השימוש מנוסחים בלשון זכר לצרכי נוחות. יש לראות את הכתוב כמתייחס לנשים וגברים כאחד, ולקרוא את הכתוב בהתאם.\n"
            "תנאי השימוש הינם מחייבים ויש לראותם כבסיס משפטי לכל דיון בינך (להלן 'המשתמש') ובין החברה ו/או כל גוף מטעמה בקשר לשימוש באפליקציה.\n"
            "קרא בעיון את תנאי השימוש בטרם השימוש באפליקציה. אם אינך מסכים לתנאי השימוש (כולם או חלקם), אינך רשאי לעשות כל שימוש באפליקציה לכל מטרה שהיא.\n\n"
            "הגבלות\n\n"
            "המשתמש מתחייב להשתמש באפליקציה בהתאם להוראות כל דין ובכפוף להוראות תנאי שימוש אלו, ואין לעשות באפליקציה שימוש למטרות בלתי חוקיות ו/או למטרות שאינן עולות בקנה אחד עם תנאי השימוש.\n"
            "המשתמש מתחייב לא לבצע כל פעולה אשר עלולה לפגוע במישרין או בעקיפין באפליקציה ו/או בפעילות האפליקציה ו/או במידע הכלול באפליקציה.\n\n"
            "זכויות יוצרים\n\n"
            "כל זכויות הקניין הרוחני באפליקציה זו, לרבות פטנטים, זכויות יוצרים, סימני מסחר, מדגמים, סודות מסחריים, ידע מקצועי וכיוצא בזה, הינם בבעלות החברה ו/או ספקי התוכן שלה.\n"
            "אין לעשות כל שימוש בזכויות אלה ללא קבלת הסכמה מפורשת מראש ובכתב מהחברה.\n\n"
            "אחריות\n\n"
            "האפליקציה מסופקת כמו שהיא (AS IS) והחברה אינה אחראית לכל נזק, ישיר או עקיף, שייגרם למשתמש או לצד שלישי כתוצאה משימוש באפליקציה.\n"
            "החברה אינה מתחייבת כי השירותים הניתנים באפליקציה יינתנו כסדרם ללא הפסקות וללא טעויות, ויהיו חסינים מפני גישה לא חוקית למחשבי החברה, נזקים, קלקולים, תקלות או כשלים בחומרה, בתוכנה או בקווי התקשורת אצל החברה או מי מספקיה או ייפגעו מכל סיבה אחרת, והחברה לא תהא אחראית לכל נזק - ישיר או עקיף - עוגמת נפש וכיו\"ב שייגרמו לך או לרכושך עקב כך.\n\n"
            "פרטיות\n\n"
            "החברה מכבדת את פרטיות המשתמשים באפליקציה. מידע אישי הנמסר לחברה על ידי המשתמשים יישמר וייעשה בו שימוש בהתאם להוראות החוק ולמדיניות הפרטיות של החברה.\n\n"
            "שינויים בתנאי השימוש\n\n"
            "החברה שומרת לעצמה את הזכות לשנות ולעדכן את תנאי השימוש מעת לעת, על פי שיקול דעתה הבלעדי. שינויים אלו ייכנסו לתוקף מיד עם פרסומם באפליקציה. המשך שימוש באפליקציה לאחר שינוי תנאי השימוש מעיד על הסכמתך לתנאים החדשים.\n\n"
            "יצירת קשר\n\n"
            "במקרה של שאלות או בירורים בנוגע לתנאי השימוש, ניתן לפנות לחברה דרך פרטי הקשר המופיעים באפליקציה.\n",
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

