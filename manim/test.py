from manim import *

class Example(Scene):
    def construct(self):
        ellipse1 = Ellipse(width=4, height=4, fill_opacity=.5, color=BLUE, stroke_width=10).move_to(LEFT)
        ellipse2 = ellipse1.copy().set_color(color = RED).move_to(RIGHT)
        set_a = MathTex(r"A", font_size = 96).move_to(LEFT*2)
        set_b = MathTex(r"B", font_size = 96).move_to(RIGHT*2)
        ellipse_group = VGroup(ellipse1, ellipse2)
        set_group = VGroup(set_a, set_b)
        ellipse_set_group = VGroup(ellipse_group, set_group)
        self.play(FadeIn(ellipse_group))
        self.wait(1)
        self.play(FadeIn(set_group))
        self.wait(1)
        self.play(ellipse_set_group.animate.scale(.7).move_to(UP))


        
        intersection = Intersection(ellipse1, ellipse2, color=GREEN, fill_opacity = .5)
        self.play(intersection.animate.scale(.5).move_to(RIGHT * 5 + UP * 2.5))

        union = Union(ellipse1, ellipse2, color=ORANGE, fill_opacity = .5)
        self.play(union.animate.scale(.5).move_to(RIGHT * 5 + DOWN * 2.5))

        exclusion = Exclusion(ellipse1, ellipse2, color=BLUE, fill_opacity = .5)
        self.play(exclusion.animate.scale(.5).move_to(LEFT * 5 + UP * 2.5))

        difference = Difference(ellipse1, ellipse2, color=PINK, fill_opacity = .5)
        self.play(difference.animate.scale(.5).move_to(LEFT * 5 + DOWN * 2.5))

## manim -pql test.py Example
