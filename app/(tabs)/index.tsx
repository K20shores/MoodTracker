import { StyleSheet } from "react-native";
import { useRef, useEffect, useState } from "react";
import { ThemedText } from "@/components/ThemedText";
import { ThemedView } from "@/components/ThemedView";
import { ThemedInput } from "@/components/ThemedInput";
import { Button, Pressable } from "react-native";
import { Audio } from 'expo-av';
import { Timer } from "@/components/Timer";

export default function Home() {
  const progressRef = useRef(null);
  const [sound, setSound] = useState();
  const [minutes, setMinutes] = useState("0");
  const [seconds, setSeconds] = useState("10");
  const [intervals, setIntervals] = useState("0");
  const [totalTime, setTotalTime] = useState(parseInt(minutes) * 60 + parseInt(seconds));

  async function playSound() {
    const { sound } = await Audio.Sound.createAsync(require('@/assets/sounds/148609__john_sauter__hand_bell.wav'));
    setSound(sound);
    await sound.playAsync();
  }

  useEffect(() => {
    return sound
      ? () => {
          sound.unloadAsync();
        }
      : undefined;
  }, [sound]);

  useEffect(() => {
    setTotalTime(parseInt(minutes) * 60 + parseInt(seconds));
  }, [minutes, seconds]);

  const onStart = async () => {
    await playSound();
    progressRef.current?.play();
  };

  const onFinished = async ({ finished }) => {
    if (finished) {
      await playSound();
    }
  };

  const onIntervalDone = async (intervalsLeft) => {
    if (intervalsLeft > 0) {
      await playSound();
    }
  }

  return (
    <ThemedView style={styles.titleContainer}>
      <ThemedView style={styles.inputContainer}>
        <ThemedView style={styles.inputWrapper}>
          <ThemedText style={styles.label}>Minutes</ThemedText>
          <ThemedInput
            keyboardType="numeric"
            placeholder="0"
            value={minutes}
            onChangeText={setMinutes}
          />
        </ThemedView>
        <ThemedView style={styles.inputWrapper}>
          <ThemedText style={styles.label}>Seconds</ThemedText>
          <ThemedInput
            keyboardType="numeric"
            placeholder="0"
            value={seconds}
            onChangeText={setSeconds}
          />
        </ThemedView>
        <ThemedView style={styles.inputWrapper}>
          <ThemedText style={styles.label}>Intervals</ThemedText>
          <ThemedInput
            keyboardType="numeric"
            placeholder="0"
            value={intervals}
            onChangeText={setIntervals}
            textLightColor="#000"
            textDarkColor="#fff"
          />
        </ThemedView>
      </ThemedView>

      <Timer
        ref={progressRef}
        time={totalTime}
        intervals={parseInt(intervals)}
        color={'#2ecc71'}
        animateToZero={true}
        callback={onFinished}
        onIntervalDone={onIntervalDone}
      />

      <ThemedView style={styles.buttonContainer}>
        <Pressable style={styles.button} onPress={onStart}>
          <ThemedText style={styles.buttonText}>Start</ThemedText>
        </Pressable>
        <Pressable style={styles.button} onPress={() => progressRef.current?.pause()}>
          <ThemedText style={styles.buttonText}>Pause</ThemedText>
        </Pressable>
        <Pressable style={styles.button} onPress={() => progressRef.current?.reset()}>
          <ThemedText style={styles.buttonText}>Reset</ThemedText>
        </Pressable>
      </ThemedView>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  titleContainer: {
    flexDirection: "column",
    flexGrow: 1,
    gap: 8,
    alignItems: "center",
    justifyContent: "center",
  },
  inputContainer: {
    flexDirection: "row",
    gap: 16,
    alignItems: "center",
    justifyContent: "center",
  },
  inputWrapper: {
    alignItems: "center",
  },
  label: {
    marginBottom: 4,
    fontSize: 16,
    fontWeight: "bold",
  },
  buttonContainer: {
    flexDirection: "row",
    gap: 8,
  },
  button: {
    backgroundColor: '#03A9F4',
    paddingVertical: 10,
    paddingHorizontal: 20,
    borderRadius: 8,
    alignItems: 'center',
  },
  buttonText: {
    color: '#19230A',
    fontSize: 16,
    fontWeight: 'bold',
  },
});
