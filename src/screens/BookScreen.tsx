import React, { useCallback, useEffect, useRef } from 'react';
import { SafeAreaView, View } from 'react-native';

import { usePublication } from '../hooks';
import { Appearance, FontFamily, ReadiumMethods, ReadiumView } from '../Readium';
import { EAppScreens, ScreenProps } from '../typescript';

interface TProps extends ScreenProps<EAppScreens.Book> {}

function Book({ route }: TProps): JSX.Element {
  const ref = useRef<ReadiumMethods>(null);
  const book = route.params.book;
  const { getPublicationFile, saveDownloadedFile, file } = usePublication();
  const settings = {
    fontSize: 150,
    appearance: Appearance.NIGHT,
    fontFamily: FontFamily.DEFAULT,
    scroll: false,
  };

  useEffect(() => {
    if (book) {
      const { id, publication } = book;
      if (publication.ebook) {
        getPublicationFile(id, publication.ebook);
      } else {
        console.warn('publication license not exist');
      }
    }
  }, [book, getPublicationFile]);

  const handleDownloaded = useCallback(
    (params: { file: string }) => {
      if (book) {
        saveDownloadedFile(params, book.id);
      }
    },
    [book, saveDownloadedFile],
  );

  console.log('file', file);

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <View style={{ flex: 1 }}>
        {file ? (
          <ReadiumView ref={ref} file={file} settings={settings} onDownloaded={handleDownloaded} />
        ) : null}
      </View>
    </SafeAreaView>
  );
}

export default Book;
