import React, {
  useEffect,
  useRef,
  useState,
  forwardRef,
  useImperativeHandle,
} from "react";
import { Easing, TextInput, Animated, View, StyleSheet } from "react-native";
import Svg, { G, Circle } from "react-native-svg";

const AnimatedTextInput = Animated.createAnimatedComponent(TextInput);

export const Timer = forwardRef(
  (
    {
      time = 300, // total time in seconds
      intervals = 0, // number of intervals
      radius = 200,
      strokeWidth = 8,
      color = "tomato",
      delay = 0,
      textColor,
      callback = () => {},
      onIntervalDone = () => {}, 
    },
    ref
  ) => {
    const animationRef = useRef(new Animated.Value(time)).current;
    const circleRef = useRef();
    const inputRef = useRef();
    const circumference = 2 * Math.PI * radius;
    const halfCircle = radius + strokeWidth;

    const [strokeDashoffset, setStrokeDashoffset] = useState(0);
    const [text, setText] = useState(formatTime(time));
    const [duration, setDuration] = useState(time * 1000);

    const [pausedValue, setPausedValue] = useState(null);

    const [currentInterval, setCurrentInterval] = useState(0);
    const [intervalDuration, setIntervalDuration] = useState(
      intervals > 0 ? time / intervals : 0
    );

    const animation = (toValue, duration) => {
      return Animated.timing(animationRef, {
        delay,
        toValue,
        duration: duration,
        useNativeDriver: false,
        easing: Easing.linear,
      });
    };

    useEffect(() => {
      if (intervals > 0) {
        setIntervalDuration(time / intervals);
      }
    }, [intervals, time]);

    useEffect(() => {
      setDuration(time * 1000);
      setText(formatTime(time));
      animationRef.setValue(time);
      setStrokeDashoffset(circumference - (circumference * time) / time); 
      setPausedValue(null);
    }, [time]);

    useEffect(() => {
      let lastInterval = 0;

      const listener = async (v) => {
        const newStrokeDashoffset =
          circumference - (circumference * v.value) / time;
        setStrokeDashoffset(newStrokeDashoffset);
        setText(formatTime(v.value));

        const elapsed = time - v.value;
        const newInterval = Math.floor(elapsed / intervalDuration);

        if (newInterval > lastInterval) {
          lastInterval = newInterval;
          setCurrentInterval(newInterval);
          const intervalsLeft = intervals - newInterval;
          await onIntervalDone(intervalsLeft);
        }
      };

      animationRef.addListener(listener);

      return () => {
        animationRef.removeListener(listener);
      };
    }, [intervals, intervalDuration, time]);

    useImperativeHandle(ref, () => ({
      play: () => {
        if (strokeDashoffset >= circumference) {
          animationRef.setValue(time);
        }
        const remainingDuration = pausedValue ? (pausedValue / time) * duration : duration;
        animation(0, remainingDuration).start(callback);
      },
      pause: () => {
        animationRef.stopAnimation(setPausedValue);
      },
      reset: () => {
        setPausedValue(null);
        animationRef.setValue(time);
      },
    }));

    return (
      <View style={{ width: radius * 2, height: radius * 2 }}>
        <Svg
          height={radius * 2}
          width={radius * 2}
          viewBox={`0 0 ${halfCircle * 2} ${halfCircle * 2}`}
        >
          <G rotation="-90" origin={`${halfCircle}, ${halfCircle}`}>
            <Circle
              ref={circleRef}
              cx="50%"
              cy="50%"
              r={radius}
              fill="transparent"
              stroke={color}
              strokeWidth={strokeWidth}
              strokeLinecap="round"
              strokeDashoffset={strokeDashoffset}
              strokeDasharray={circumference}
            />
            <Circle
              cx="50%"
              cy="50%"
              r={radius}
              fill="transparent"
              stroke={color}
              strokeWidth={strokeWidth}
              strokeLinejoin="round"
              strokeOpacity=".1"
            />
          </G>
        </Svg>
        <AnimatedTextInput
          ref={inputRef}
          underlineColorAndroid="transparent"
          editable={false}
          style={[
            StyleSheet.absoluteFillObject,
            { fontSize: radius / 2, color: textColor ?? color },
            styles.text,
          ]}
          value={text}
        />
      </View>
    );
  }
);

const formatTime = (seconds) => {
  const mins = Math.floor(seconds / 60);
  const secs = Math.ceil(seconds % 60);
  return `${mins}:${secs < 10 ? "0" : ""}${secs}`;
};

const styles = StyleSheet.create({
  text: { fontWeight: "900", textAlign: "center" },
});
