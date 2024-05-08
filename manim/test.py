from manim import *

class Example(Scene):
    def construct(self):
        ellipse1 = Ellipse(width=4, height=4, fill_opacity=.5, color=BLUE, stroke_width=10).move_to(LEFT)
        ellipse2 = ellipse1.copy().set_color(color = RED).move_to(RIGHT)
        ellipse_group = Group(ellipse1, ellipse2)
        self.play(FadeIn(ellipse_group))

        
        intersection = Intersection(ellipse1, ellipse2, color=GREEN, fill_opacity = .5)
        self.play(intersection.animate.scale(.5).move_to(RIGHT * 5 + UP * 2.5))

        union = Union(ellipse1, ellipse2, color=ORANGE, fill_opacity = .5)
        self.play(union.animate.scale(.5).next_to(intersection, DOWN))

        exclusion = Exclusion(ellipse1, ellipse2, color=BLUE, fill_opacity = .5)
        self.play(exclusion.animate.scale(.5).next_to(union, DOWN))

        difference = Difference(ellipse1, ellipse2, color=PINK, fill_opacity = .5)
        self.play(difference.animate.scale(.5).next_to(exclusion, DOWN))

