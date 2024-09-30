import { TextInput, StyleSheet, type TextInputProps } from 'react-native';

import { useThemeColor } from '@/hooks/useThemeColor';

export type ThemedInputProps = TextInputProps & {
  lightColor?: string;
  darkColor?: string;
  textLightColor?: string;
  textDarkColor?: string;
  type?: 'default' | 'outlined' | 'filled';
};

export function ThemedInput({
  style,
  lightColor,
  darkColor,
  textLightColor,
  textDarkColor,
  type = 'default',
  ...rest
}: ThemedInputProps) {
  const textColor = useThemeColor(
    { light: textLightColor, dark: textDarkColor }, 
    'text', 
  );

  return (
    <TextInput
      style={[
        {
          color: textColor,
        },
        type === 'default' ? styles.default : undefined,
        type === 'outlined' ? styles.outlined : undefined,
        type === 'filled' ? styles.filled : undefined,
        styles.input,
        style,
      ]}
      {...rest}
    />
  );
}

const styles = StyleSheet.create({
  input: {
    borderRadius: 2,
    borderWidth: 1,
    borderColor: "#ccc",
    padding: 8,
    width: 80,
    textAlign: "center",
  },
  default: {
    fontSize: 16,
    padding: 10,
    borderWidth: 1,
    borderRadius: 5,
  },
  outlined: {
    fontSize: 16,
    padding: 10,
    borderWidth: 2,
    borderRadius: 5,
  },
  filled: {
    fontSize: 16,
    padding: 10,
    borderRadius: 5,
    backgroundColor: '#e0e0e0',
  },
});
