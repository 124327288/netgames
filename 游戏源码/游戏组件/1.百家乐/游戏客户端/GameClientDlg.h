#pragma once

#include "Stdafx.h"
#include "GameClientView.h"

//////////////////////////////////////////////////////////////////////////

//��Ϸ�Ի���
class CGameClientDlg : public CGameFrameDlg
{
	//������Ϣ
protected:
	LONG							m_lMeMaxScore;						//�����ע
	LONG							m_lAreaLimitScore;					//��������

	//��ע��Ϣ
protected:
	LONG							m_lMeTieScore;						//��ƽ��ע
	LONG							m_lMeBankerScore;					//��ׯ��ע
	LONG							m_lMePlayerScore;					//������ע
	LONG							m_lMeTieSamePointScore;				//ͬ��ƽע
	LONG							m_lMePlayerKingScore;				//������ע
	LONG							m_lMeBankerKingScore;				//ׯ����ע

	//״̬����
protected:
	bool							m_bPlaying;							//��Ϸ״̬
	int								m_nShowResultTime;					//��ʾʱ��

	//�˿���Ϣ
protected:
	BYTE							m_cbCardCount[2];					//�˿���Ŀ
	BYTE							m_cbSendCount[2];					//�˿���Ŀ
    BYTE							m_cbTableCardArray[2][3];			//�����˿�
	CString							m_strDispatchCardTips;				//������ʾ

	//��ʷ��Ϣ
protected:
	WORD							m_wDrawCount;						//��Ϸ����
	LONG							m_lMeResultCount;					//��Ϸ�ɼ�

	//ׯ����Ϣ
protected:
	LONG							m_lApplyBankerCondition;			//��������
	LONG							m_lBankerScore;						//ׯ�һ���
	WORD							m_wCurrentBanker;					//��ǰׯ��
	bool							m_bMeApplyBanker;					//�����ʶ

	//�ؼ�����
protected:
	CGameLogic						m_GameLogic;						//��Ϸ�߼�
	CGameClientView					m_GameClientView;					//��Ϸ��ͼ
	
	//��������
public:
	//���캯��
	CGameClientDlg();
	//��������
	virtual ~CGameClientDlg();

	//����̳�
private:
	//��ʼ����
	virtual bool InitGameFrame();
	//���ÿ��
	virtual void ResetGameFrame();
	//��Ϸ����
	virtual void OnGameOptionSet();
	//ʱ����Ϣ
	virtual bool OnTimerMessage(WORD wChairID, UINT nElapse, UINT nTimerID);
	//�Թ�״̬
	virtual void OnLookonChanged(bool bLookonUser, const void * pBuffer, WORD wDataSize);
	//������Ϣ
	virtual bool OnGameMessage(WORD wSubCmdID, const void * pBuffer, WORD wDataSize);
	//��Ϸ����
	virtual bool OnGameSceneMessage(BYTE cbGameStatus, bool bLookonOther, const void * pBuffer, WORD wDataSize);
	//ȡ����Ϣ
	virtual void OnCancel();

	//��Ϣ����
protected:
	//��Ϸ��ʼ
	bool OnSubGameStart(const void * pBuffer, WORD wDataSize);
	//�û���ע
	bool OnSubPlaceJetton(const void * pBuffer, WORD wDataSize);
	//��Ϸ����
	bool OnSubGameEnd(const void * pBuffer, WORD wDataSize);
	//������ׯ
	bool OnUserApplyBanker(const void * pBuffer, WORD wDataSize);
	//�л�ׯ��
	bool OnChangeBanker(const void * pBuffer, WORD wDataSize);
	//���»���
	bool OnChangeUserScore(const void * pBuffer, WORD wDataSize);
	//��Ϸ��¼
	bool OnSubGameRecord(const void * pBuffer, WORD wDataSize);
	//��Ϸ����
	bool OnSubGameScore(const void * pBuffer, WORD wDataSize);

	//���ܺ���
protected:
	//���¿���
	void UpdateButtonContron();
	//�ɷ��˿�
	bool DispatchUserCard(BYTE cbPlayerCard[], BYTE cbPlayerCount, BYTE cbBankerCard[], BYTE cbBankerCount);
	//������ʾ
	void SetDispatchCardTips();
	//�ƶ�Ӯ��
	void DeduceWinner(BYTE &cbWinner, BYTE &cbKingWinner);

	//��Ϣӳ��
protected:
	//��ʱ����Ϣ
	afx_msg void OnTimer(UINT nIDEvent);
	//��ע��Ϣ
	LRESULT OnPlaceJetton(WPARAM wParam, LPARAM lParam);
	//������Ϣ
	LRESULT OnApplyBanker(WPARAM wParam, LPARAM lParam);

	DECLARE_MESSAGE_MAP()
};

//////////////////////////////////////////////////////////////////////////
