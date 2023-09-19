import type { ViewStyle } from 'react-native';

import type { File } from './File';
import type { Link } from './Link';
import type { Locator } from './Locator';
import type { Settings } from './Settings';

export interface AudioPlayback {
  duration: number;
  time: number;
  progress: number;
  currentResource: number;
  isPlaying: boolean;
}

export type BaseReadiumViewProps = {
  file: File;
  location?: Locator | Link;
  settings?: Partial<Settings>;
  style?: ViewStyle;
  onLocationChange?: (locator: Locator) => void;
  onTableOfContents?: (toc: Link[] | null) => void;
  onReady?: (params: { totalPages: number }) => void;
  onFullModeChange?: (fullMode: boolean) => void;
  onDownloaded?: (params: { file: string }) => void;
  onAudioPlaybackChange?: (playback: AudioPlayback) => void;
  onDownloading?: (progress: number) => void;
  ref?: any;
  height?: number;
  width?: number;
};
