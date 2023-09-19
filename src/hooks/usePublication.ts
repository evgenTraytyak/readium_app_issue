import {useCallback, useState} from 'react';
import RNFS from 'react-native-fs';

import {File} from '../Readium';
import {Locator} from '../Readium';

export interface TPublication {
  license: string;
  passphrase: string;
  progress: number;
}
export interface TLastPosition {
  locator: Locator;
  bookId: string;
  type: EReaderType;
}

export enum EReaderType {
  Text = 'text',
  Audio = 'audio',
}

export interface TImageFile {
  url: string;
  thumbnailUrl: string;
}

export interface TCompanyDocument {
  id: string;
  title: string;
  url?: string;
  image?: TImageFile;
}

export const usePublication = () => {
  const [file, setFile] = useState<File>();
  const [downloadedBooks, setDownloadedBooks] = useState({});

  console.log('downloadedBooks', downloadedBooks);

  const getPublicationFile = useCallback(
    async (
      bookId: string,
      {license, passphrase}: TPublication,
      initialPosition?: TLastPosition,
    ) => {
      if (!file) {
        try {
          const bookPath = downloadedBooks[bookId];
          console.log('bookPath', bookPath);
          let filePath = `${RNFS.CachesDirectoryPath}/license.lcpl`;

          if (bookPath) {
            filePath = `${RNFS.DocumentDirectoryPath}/${bookPath}`;
          } else {
            await RNFS.writeFile(filePath, license);
          }

          const isExist = await RNFS.exists(filePath);

          if (isExist) {
            console.log('setFile', filePath);
            setFile({
              url: `file://${filePath}`,
              passpharse: passphrase,
              initialLocation:
                initialPosition?.bookId === bookId
                  ? initialPosition?.locator
                  : undefined,
            });
          }
        } catch {}
      }
    },
    [file, downloadedBooks],
  );

  const saveDownloadedFile = useCallback(
    (params: {file: string}, bookId: string) => {
      setDownloadedBooks({
        ...downloadedBooks,
        [bookId]: params.file,
      });
    },
    [downloadedBooks],
  );

  return {
    getPublicationFile,
    saveDownloadedFile,
    file,
  };
};
