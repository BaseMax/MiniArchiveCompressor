#include "fileprocessor.h"

FileProcessor::FileProcessor(QObject *parent) : QObject(parent)
{

}

bool FileProcessor::copy(const QString filepath)
{
    QDateTime date = QDateTime::currentDateTime();
    QStringList splittedpath = filepath.split("/");
    QString filename = splittedpath[splittedpath.size() - 1];
    return QFile::copy(filepath, "/tmp/" + date.toString("dd-MM-yy-hh-mm-ss-") + filename);
}
