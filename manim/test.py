from manim import *

class Example(Scene):
    def construct(self):
        ellipse1 = Ellipse(width=4, height=4, fill_opacity=.5, color=BLUE, stroke_width=10).move_to(LEFT)
        ellipse2 = ellipse1.copy().set_color(color = RED).move_to(RIGHT)
        ellipse_group = Group(ellipse1, ellipse2)
        self.play(FadeIn(ellipse_group))
