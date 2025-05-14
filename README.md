# Fui

<img src="media/loading-animation.png" width="50%"/>

## Fui structure
Fui follows the Flat architecture. Its differences in the core and build tools are the addition of layers of obfuscation in compiling Python application code and managing extensions and building local modules specific to each specific version of the project.

## Fui app example

```python title="counter.py"
import fui as fi

def main(page: fi.Page):
    page.title = "Fui counter example"
    page.vertical_alignment = fi.MainAxisAlignment.CENTER

    txt_number = fi.TextField(value="0", text_align=fi.TextAlign.RIGHT, width=100)

    def minus_click(e):
        txt_number.value = str(int(txt_number.value) - 1)
        page.update()

    def plus_click(e):
        txt_number.value = str(int(txt_number.value) + 1)
        page.update()

    page.add(
        fi.Row(
            [
                fi.IconButton(fi.Icons.REMOVE, on_click=minus_click),
                txt_number,
                fi.IconButton(fi.Icons.ADD, on_click=plus_click),
            ],
            alignment=fi.alignment.center,
        )
    )

fi.app(main)
```

run this for install `fui` module:

```bash
pip install fui[all]
```

and run the program:

```bash
python counter.py
```
