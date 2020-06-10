#ifndef MODEL_H
#define MODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include <QFileInfo>
#include <QMimeType>
#include <QMimeDatabase>

#define DB_HOSTNAME    "localhost"
#define DB_NAME        "modeldb.db"
#define DB_TABLE       "debtors"


class Model : public QAbstractListModel
{
    Q_OBJECT

public:
    /*
     * roles for each column. ROLE_END is a flag for iteration convenience
     */
    enum {
        pathRole = Qt::UserRole + 1,
        sizeRole,
        typeRole,
        mimetypeRole,
        ROLE_END
    };

    explicit Model(QObject *parent = nullptr);
    // return number of data's
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    // return data by role and index
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    // set data by role and index
//    bool setData(const QModelIndex &index, const QVariant &value,
//                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool insert(const QString& filename, const QString& size, const QString& type, const QString& mimetype,  const QString& path, const QModelIndex &parent = QModelIndex());

public slots:
    // remove an element by index
    bool remove(int index, const QModelIndex &parent = QModelIndex());
    bool prepareAndInsert(QString filepath);
    QString getFileInfo(int index) const;

private:
    QList<QVariantList> vlist;
    // list of columns
    const QList<QByteArray> columns{"filename", "size", "type", "mimetype"};

};

#endif // MODEL_H
