from fui import Page, Text, app

def main(page: Page):
    page.add(Text("Hello, world!"))

app(target=main)