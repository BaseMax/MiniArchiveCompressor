#include "model.h"
#include <QDebug>

Model::Model(QObject *parent)
    : QAbstractListModel(parent)
{
}

int Model::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return vlist.size();
}

QVariant Model::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || vlist.size() <= 0)
        return QVariant();

    QVariantList temp = vlist.at(index.row());
    switch (role) {
        case pathRole:
            return temp[0];
        case sizeRole:
            return temp[1];
        case typeRole:
            return temp[2];
        case mimetypeRole:
            return temp[3];
    }
    return QVariant();
}


//bool Model::setData(const QModelIndex &index, const QVariant &value, int role)
//{
//    int indexrow = index.row();
//    if (data(index, role) != value && vlist.size() > indexrow) {

//        switch (role) {

//            case fnameRole:
//                vlist[indexrow][1] = value.toString();
//            break;
//            case debtRole:
//                vlist[indexrow][2] = value.toString();
//            break;
//            case picRole:
//                vlist[indexrow][3] = value.toString();
//            break;
//        }
//        emit dataChanged(index, index, QVector<int>() << role);
//        return true;
//    }
//    return false;
//}

Qt::ItemFlags Model::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> Model::roleNames() const
{
    QHash<int, QByteArray> roles;
    int column_number{0};
    for (int i{pathRole}; i != ROLE_END; ++i, ++column_number) {
        roles.insert(i, this->columns[column_number]);
    }
    return roles;
}

bool Model::insert(const QString& filename, const QString& size, const QString& type, const QString& mimetype, const QString& path, const QModelIndex &parent)
{
    int rowcount = rowCount();
    beginInsertRows(parent, rowcount, rowcount);

    QVariantList temp;
    temp.append(filename);
    temp.append(size);
    temp.append(type);
    temp.append(mimetype);
    temp.append(path);
    vlist.push_back(temp);
    endInsertRows();
    return true;
}

bool Model::prepareAndInsert(QString filepath)
{
    filepath.replace("file://", "");
    QFileInfo info(filepath);
    const QStringList splitedpath = filepath.split("/");
    const QString mimetype = QMimeType(QMimeDatabase().mimeTypeForFile(info)).name();
    const QStringList postfix{" B", " KB", " MB", " GB", " TB"};
    QString filename = splitedpath[splitedpath.size() - 2] + "/" + splitedpath[splitedpath.size() - 1];
    const size_t filenamesize = filename.size();
    qint64 size{info.size()};
    if (size == 0) {
        return false;
    }
    if (filenamesize > 40) {
        const int temp = filenamesize - (filenamesize % 40);
        filename.remove(temp, filenamesize);
        filename += "...";
    }
    qDebug() << filenamesize;
    qDebug() << filename.size();
    size_t i{0};
    for (; i <= 4; ++i) {
        if (size > 1024) {
            size /= 1024;
        }else {
            break;
        }
    }
    insert(filename, QString(QString::number(size) + postfix[i]), info.suffix(), mimetype, filepath);
    return true;
}

QString Model::getFileInfo(int index) const
{
    return vlist[index][4].toString();
}


bool Model::remove(int index, const QModelIndex& parent) {
        beginRemoveRows(parent, index, index);
        vlist.removeAt(index);
        endRemoveRows();
        return true;
}


