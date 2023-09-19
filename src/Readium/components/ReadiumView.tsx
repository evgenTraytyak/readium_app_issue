import React, {
  forwardRef,
  useCallback,
  useEffect,
  useImperativeHandle,
  useRef,
} from 'react';
import {findNodeHandle, Platform, UIManager} from 'react-native';

import type {BaseReadiumViewProps, Link, Locator} from '../interfaces';
import {Settings} from '../interfaces';
import {BaseReadiumView} from './BaseReadiumView';

export type ReadiumProps = BaseReadiumViewProps;

export type ReadiumMethods = {
  goToPosition: (position: number) => void;
  goToLocation: (location: Locator | Link) => void;
  pause: () => void;
  play: () => void;
  seek: (value: number) => void;
  setRate: (value: number) => void;
  goNext: () => void;
  goPrevious: () => void;
};

export const ReadiumView = forwardRef<ReadiumMethods, ReadiumProps>(
  (
    {
      onLocationChange: wrappedOnLocationChange,
      onTableOfContents: wrappedOnTableOfContents,
      onReady: wrappedOnReady,
      onFullModeChange: wrappedOnFullModeChange,
      onDownloaded: wrappedOnDownloaded,
      onAudioPlaybackChange: wrappedOnPlaybackChange,
      onDownloading: wrappedOnDownloading,
      settings: unmappedSettings,
      ...props
    },
    ref,
  ) => {
    const readerRef = useRef(null);
    // wrap the native onLocationChange and extract the raw event value
    const onLocationChange = useCallback(
      (event: any) => {
        if (wrappedOnLocationChange) {
          wrappedOnLocationChange(event.nativeEvent);
        }
      },
      [wrappedOnLocationChange],
    );

    const onTableOfContents = useCallback(
      (event: any) => {
        if (wrappedOnTableOfContents) {
          const toc = event.nativeEvent.toc || null;
          wrappedOnTableOfContents(toc);
        }
      },
      [wrappedOnTableOfContents],
    );

    const onReady = useCallback(
      (event: any) => {
        if (wrappedOnReady) {
          const totalPages = event.nativeEvent.totalPages || 0;
          wrappedOnReady({totalPages});
        }
      },
      [wrappedOnReady],
    );

    const onFullModeChange = useCallback(
      (event: any) => {
        if (wrappedOnFullModeChange) {
          const fullMode = event.nativeEvent.fullMode || false;
          wrappedOnFullModeChange(fullMode);
        }
      },
      [wrappedOnFullModeChange],
    );

    const onDownloaded = useCallback(
      (event: any) => {
        if (wrappedOnDownloaded) {
          const path = event.nativeEvent.path || null;
          wrappedOnDownloaded({file: path});
        }
      },
      [wrappedOnDownloaded],
    );

    const onPlaybackChange = useCallback(
      (event: any) => {
        if (wrappedOnPlaybackChange) {
          const position = event.nativeEvent || null;
          wrappedOnPlaybackChange(position);
        }
      },
      [wrappedOnPlaybackChange],
    );

    const onDownloading = useCallback(
      (event: any) => {
        if (wrappedOnDownloading) {
          const progress = event.nativeEvent.progress || null;
          wrappedOnDownloading(progress);
        }
      },
      [wrappedOnDownloading],
    );

    const goToPosition = (position: number) => {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(readerRef.current),
        'goToPosition',
        [position],
      );
    };

    const goToAudioPosition = (position: number) => {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(readerRef.current),
        'goToAudioPosition',
        [position],
      );
    };

    const goToLocation = (location: Locator | Link) => {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(readerRef.current),
        'goToLocation',
        [location],
      );
    };

    const play = () => {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(readerRef.current),
        'playAudio',
        [],
      );
    };

    const pause = () => {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(readerRef.current),
        'pauseAudio',
        [],
      );
    };

    const seek = (value: number) => {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(readerRef.current),
        'seekAudio',
        [value],
      );
    };

    const setRate = (value: number) => {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(readerRef.current),
        'setAudioRate',
        [value],
      );
    };

    const goNext = () => {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(readerRef.current),
        'goToNextAudio',
        [],
      );
    };

    const goPrevious = () => {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(readerRef.current),
        'goToPreviousAudio',
        [],
      );
    };

    useImperativeHandle(ref, () => ({
      goToPosition,
      goToLocation,
      play,
      pause,
      seek,
      goToAudioPosition,
      setRate,
      goNext,
      goPrevious,
    }));

    useEffect(() => {
      if (Platform.OS === 'android') {
        const viewId = findNodeHandle(readerRef.current);
        UIManager.dispatchViewManagerCommand(viewId, 'create', [viewId]);
      }
    }, []);

    return (
      <BaseReadiumView
        style={{flex: 1}}
        {...props}
        onLocationChange={onLocationChange}
        onTableOfContents={onTableOfContents}
        onReady={onReady}
        onAudioPlaybackChange={onPlaybackChange}
        onDownloaded={onDownloaded}
        onFullModeChange={onFullModeChange}
        onDownloading={onDownloading}
        settings={unmappedSettings ? Settings.map(unmappedSettings) : undefined}
        ref={readerRef}
      />
    );
  },
);
