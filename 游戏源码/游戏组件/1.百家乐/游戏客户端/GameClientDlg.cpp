#include "Stdafx.h"
#include "GameClient.h"
#include "GameClientDlg.h"

//////////////////////////////////////////////////////////////////////////

//ʱ���ʶ
#define IDI_PLACE_JETTON			100									//��עʱ��
#define IDI_DISPATCH_CARD			301									//����ʱ��
#define IDI_SHOW_GAME_RESULT		302									//��ʾ���

//////////////////////////////////////////////////////////////////////////

BEGIN_MESSAGE_MAP(CGameClientDlg, CGameFrameDlg)
	ON_WM_TIMER()
	ON_MESSAGE(IDM_PLACE_JETTON,OnPlaceJetton)
	ON_MESSAGE(IDM_APPLY_BANKER, OnApplyBanker)
END_MESSAGE_MAP()

//////////////////////////////////////////////////////////////////////////

//���캯��
CGameClientDlg::CGameClientDlg() : CGameFrameDlg(&m_GameClientView)
{
	//��ע��Ϣ
	m_lMeMaxScore=0L;
	m_lMeTieScore=0L;
	m_lMeBankerScore=0L;
	m_lMePlayerScore=0L;
	m_lMeTieSamePointScore=0L;
	m_lMePlayerKingScore=0L;
	m_lMeBankerKingScore=0L;

	m_lAreaLimitScore=0L;	
	m_strDispatchCardTips = TEXT("");


	//��ʷ��Ϣ
	m_wDrawCount=1;
	m_lMeResultCount=0;

	//״̬����
	m_bPlaying = false;

	//�˿���Ϣ
	ZeroMemory(m_cbCardCount,sizeof(m_cbCardCount));
	ZeroMemory(m_cbSendCount,sizeof(m_cbSendCount));
	ZeroMemory(m_cbTableCardArray,sizeof(m_cbTableCardArray));

	//ׯ����Ϣ
	m_lApplyBankerCondition = 100000000;
	m_wCurrentBanker = INVALID_CHAIR;
	m_bMeApplyBanker = false;

	return;
}

//��������
CGameClientDlg::~CGameClientDlg()
{
}

//��ʼ����
bool CGameClientDlg::InitGameFrame()
{
	//���ñ���
	SetWindowText(TEXT("�ټ�����Ϸ  --  Ver��6.0.1.0"));

	//����ͼ��
	HICON hIcon=LoadIcon(AfxGetInstanceHandle(),MAKEINTRESOURCE(IDR_MAINFRAME));
	SetIcon(hIcon,TRUE);
	SetIcon(hIcon,FALSE);

	return true;
}

//���ÿ��
void CGameClientDlg::ResetGameFrame()
{
	//��ע��Ϣ
	m_lMeMaxScore=0L;
	m_lMeTieScore=0L;
	m_lMeBankerScore=0L;
	m_lMePlayerScore=0L;
	m_lMeTieSamePointScore=0L;
	m_lMePlayerKingScore=0L;
	m_lMeBankerKingScore=0L;
	
	m_lAreaLimitScore=0L;	
	m_strDispatchCardTips = TEXT("");
    
	//��ʷ��Ϣ
	m_wDrawCount=1;
	m_lMeResultCount=0;

	//״̬����
	m_bPlaying = false;
	m_bMeApplyBanker = false;

	//ׯ����Ϣ
	m_lApplyBankerCondition = 100000000;
	m_wCurrentBanker = INVALID_CHAIR;

	//�˿���Ϣ
	ZeroMemory(m_cbCardCount,sizeof(m_cbCardCount));
	ZeroMemory(m_cbSendCount,sizeof(m_cbSendCount));
	ZeroMemory(m_cbTableCardArray,sizeof(m_cbTableCardArray));

	return;
}

//��Ϸ����
void CGameClientDlg::OnGameOptionSet()
{
	return;
}

//ʱ����Ϣ
bool CGameClientDlg::OnTimerMessage(WORD wChairID, UINT nElapse, UINT nTimerID)
{
	if ((nTimerID==IDI_PLACE_JETTON)&&(nElapse==0))
	{
		//���ù��
		m_GameClientView.SetCurrentJetton(0L);

		//��ֹ��ť
		m_GameClientView.m_btJetton100.EnableWindow(FALSE);
		m_GameClientView.m_btJetton1000.EnableWindow(FALSE);
		m_GameClientView.m_btJetton10000.EnableWindow(FALSE);
		m_GameClientView.m_btJetton100000.EnableWindow(FALSE);
		m_GameClientView.m_btJetton500.EnableWindow(FALSE);
		m_GameClientView.m_btJetton50000.EnableWindow(FALSE);
		m_GameClientView.m_btJetton500000.EnableWindow(FALSE);

		//ׯ�Ұ�ť
		m_GameClientView.m_btApplyBanker.EnableWindow( FALSE );
		m_GameClientView.m_btCancelBanker.EnableWindow( FALSE );

		//��������
		PlayGameSound(AfxGetInstanceHandle(),TEXT("STOP_JETTON"));
	}

	return true;
}

//�Թ�״̬
void CGameClientDlg::OnLookonChanged(bool bLookonUser, const void * pBuffer, WORD wDataSize)
{
}

//������Ϣ
bool CGameClientDlg::OnGameMessage(WORD wSubCmdID, const void * pBuffer, WORD wDataSize)
{
	switch (wSubCmdID)
	{
	case SUB_S_GAME_START:		//��Ϸ��ʼ
		{
			return OnSubGameStart(pBuffer,wDataSize);
		}
	case SUB_S_PLACE_JETTON:	//�û���ע
		{
			return OnSubPlaceJetton(pBuffer,wDataSize);
		}
	case SUB_S_APPLY_BANKER:	//������ׯ
		{
			return OnUserApplyBanker( pBuffer, wDataSize );
		}
	case SUB_S_CHANGE_BANKER:	//�л�ׯ��
		{
			return OnChangeBanker( pBuffer, wDataSize );
		}
	case SUB_S_CHANGE_USER_SCORE://���»���
		{
			return OnChangeUserScore( pBuffer, wDataSize );
		}
	case SUB_S_GAME_END:		//��Ϸ����
		{
			return OnSubGameEnd(pBuffer,wDataSize);
		}
	case SUB_S_SEND_RECORD:		//��Ϸ��¼
		{
			return OnSubGameRecord(pBuffer,wDataSize);
		}
	case SUB_S_GAME_SCORE:		//��Ϸ����
		{
			return OnSubGameScore(pBuffer, wDataSize);
		}
	}

	//�������
	ASSERT(FALSE);

	return true;
}

//��Ϸ����
bool CGameClientDlg::OnGameSceneMessage(BYTE cbGameStation, bool bLookonOther, const void * pBuffer, WORD wDataSize)
{
	switch (cbGameStation)
	{
	case GS_FREE:			//����״̬
		{
			//Ч������
			ASSERT(wDataSize==sizeof(CMD_S_StatusFree));
			if (wDataSize!=sizeof(CMD_S_StatusFree)) return false;

			//��Ϣ����
			CMD_S_StatusFree * pStatusFree=(CMD_S_StatusFree *)pBuffer;

			//ׯ�ұ���
			m_lApplyBankerCondition = pStatusFree->lApplyBankerCondition;			

			//����λ��
			WORD wMeChairID=GetMeChairID();
			m_GameClientView.SetMeChairID(SwitchViewChairID(wMeChairID));
			m_GameClientView.SetHistoryScore(m_wDrawCount,m_lMeResultCount);

			//�����ע
			m_GameClientView.SetMeMaxScore(pStatusFree->lMeMaxScore);
			m_GameClientView.SetAreaLimitScore( pStatusFree->lAreaLimitScore );

			m_GameClientView.SetMeTieScore(pStatusFree->lMeTieScore);
			m_GameClientView.SetMeBankerScore(pStatusFree->lMeBankerScore);
			m_GameClientView.SetMePlayerScore(pStatusFree->lMePlayerScore);
			m_GameClientView.SetMeBankerKingScore(pStatusFree->lMeBankerKingScore);
			m_GameClientView.SetMePlayerKingScore(pStatusFree->lMePlayerKingScore);
			m_GameClientView.SetMeTieSamePointScore(pStatusFree->lMeTieKingScore);

			m_wCurrentBanker = pStatusFree->wCurrentBankerChairID;

			//���ñ���
			m_lMeMaxScore= pStatusFree->lMeMaxScore ;
			m_lMeTieScore=pStatusFree->lMeTieScore;
			m_lMeBankerScore=pStatusFree->lMeBankerScore;
			m_lMePlayerScore=pStatusFree->lMePlayerScore;
			m_lMeTieSamePointScore = pStatusFree->lMeTieKingScore;
			m_lMeBankerKingScore = pStatusFree->lMeBankerKingScore;
			m_lMePlayerKingScore = pStatusFree->lMePlayerKingScore;

			//ׯ����Ϣ
			if ( pStatusFree->wCurrentBankerChairID == INVALID_CHAIR )
				m_GameClientView.SetBankerInfo( INVALID_CHAIR, pStatusFree->cbBankerTime, pStatusFree->lBankerScore );
			else
				m_GameClientView.SetBankerInfo( SwitchViewChairID( pStatusFree->wCurrentBankerChairID ), pStatusFree->cbBankerTime, pStatusFree->lBankerScore );
			m_GameClientView.SetBankerTreasure(pStatusFree->lBankerTreasure);

			//��ע����
			m_GameClientView.PlaceUserJetton(ID_PING_JIA,pStatusFree->lTieScore);
			m_GameClientView.PlaceUserJetton(ID_TONG_DIAN_PING,pStatusFree->lTieSamePointScore);
			m_GameClientView.PlaceUserJetton(ID_XIAN_JIA,pStatusFree->lPlayerScore);
			m_GameClientView.PlaceUserJetton(ID_XIAN_TIAN_WANG,pStatusFree->lPlayerKingScore);
			m_GameClientView.PlaceUserJetton(ID_ZHUANG_JIA,pStatusFree->lBankerScore);
			m_GameClientView.PlaceUserJetton(ID_ZHUANG_TIAN_WANG,pStatusFree->lBankerKingScore);

			//���¿���
			UpdateButtonContron();

			//��������
			PlayGameSound(AfxGetInstanceHandle(),TEXT("PLACE_JETTON"));

			//����ʱ��
			SetGameTimer(GetMeChairID(),IDI_PLACE_JETTON,pStatusFree->cbTimeLeave);

			return true;
		}
	case GS_PLAYING:		//��Ϸ״̬
		{
			//Ч������
			ASSERT(wDataSize==sizeof(CMD_S_StatusPlay));
			if (wDataSize!=sizeof(CMD_S_StatusPlay)) return false;

			//��Ϣ����
			CMD_S_StatusPlay * pStatusPlay=(CMD_S_StatusPlay *)pBuffer;

			//ׯ�ұ���
			m_lApplyBankerCondition = pStatusPlay->lApplyBankerCondition;

			//���ñ���
			m_lMeMaxScore=pStatusPlay->lMeMaxScore ;
			m_lMeTieScore=pStatusPlay->lMeTieScore;
			m_lMeBankerScore=pStatusPlay->lMeBankerScore;
			m_lMePlayerScore=pStatusPlay->lMePlayerScore;
			m_lMeTieSamePointScore = pStatusPlay->lMeTieKingScore;
			m_lMeBankerKingScore = pStatusPlay->lMeBankerKingScore;
			m_lMePlayerKingScore = pStatusPlay->lMePlayerKingScore;

			//����λ��
			WORD wMeChairID=GetMeChairID();
			m_GameClientView.SetMeChairID(SwitchViewChairID(wMeChairID));
			m_GameClientView.SetHistoryScore(m_wDrawCount,m_lMeResultCount);

			//�����ע
			m_GameClientView.SetMeMaxScore(pStatusPlay->lMeMaxScore);	
			m_GameClientView.SetAreaLimitScore( pStatusPlay->lAreaLimitScore );

			m_GameClientView.SetMeTieScore(pStatusPlay->lMeTieScore);
			m_GameClientView.SetMeBankerScore(pStatusPlay->lMeBankerScore);
			m_GameClientView.SetMePlayerScore(pStatusPlay->lMePlayerScore);
			m_GameClientView.SetMeBankerKingScore(pStatusPlay->lMeBankerKingScore);
			m_GameClientView.SetMePlayerKingScore(pStatusPlay->lMePlayerKingScore);
			m_GameClientView.SetMeTieSamePointScore(pStatusPlay->lMeTieKingScore);

			//ׯ����Ϣ
			m_wCurrentBanker = pStatusPlay->wCurrentBankerChairID;
			if ( pStatusPlay->wCurrentBankerChairID == INVALID_CHAIR )
				m_GameClientView.SetBankerInfo( INVALID_CHAIR, pStatusPlay->cbBankerTime, pStatusPlay->lBankerScore );
			else
				m_GameClientView.SetBankerInfo( SwitchViewChairID( pStatusPlay->wCurrentBankerChairID ), pStatusPlay->cbBankerTime, pStatusPlay->lCurrentBankerScore );
			m_GameClientView.SetBankerTreasure(pStatusPlay->lBankerTreasure);


			//��ע����
			m_GameClientView.PlaceUserJetton(ID_PING_JIA,pStatusPlay->lTieScore);
			m_GameClientView.PlaceUserJetton(ID_TONG_DIAN_PING,pStatusPlay->lTieSamePointScore);
			m_GameClientView.PlaceUserJetton(ID_XIAN_JIA,pStatusPlay->lPlayerScore);
			m_GameClientView.PlaceUserJetton(ID_XIAN_TIAN_WANG,pStatusPlay->lPlayerKingScore);
			m_GameClientView.PlaceUserJetton(ID_ZHUANG_JIA,pStatusPlay->lBankerScore);
			m_GameClientView.PlaceUserJetton(ID_ZHUANG_TIAN_WANG,pStatusPlay->lBankerKingScore);

			//��������
			PlayGameSound(AfxGetInstanceHandle(),TEXT("GAME_START"));

			//�����˿�
			DispatchUserCard(pStatusPlay->cbTableCardArray[INDEX_PLAYER],pStatusPlay->cbCardCount[INDEX_PLAYER],
				pStatusPlay->cbTableCardArray[INDEX_BANKER],pStatusPlay->cbCardCount[INDEX_BANKER]);

			//���ð�ť
			m_GameClientView.m_btApplyBanker.EnableWindow( FALSE );
			m_GameClientView.m_btCancelBanker.EnableWindow( FALSE );

			return true;
		}
	}

	return false;
}

//��Ϸ��ʼ
bool CGameClientDlg::OnSubGameStart(const void * pBuffer, WORD wDataSize)
{
	//Ч������
	ASSERT(wDataSize==sizeof(CMD_S_GameStart));
	if (wDataSize!=sizeof(CMD_S_GameStart)) return false;

	//��Ϣ����
	CMD_S_GameStart * pGameStart=(CMD_S_GameStart *)pBuffer;

	//����״̬
	SetGameStatus(GS_PLAYING);
	KillGameTimer(IDI_PLACE_JETTON);

	//���¿���
	UpdateButtonContron();

	//�ɷ��˿�
	DispatchUserCard(pGameStart->cbTableCardArray[INDEX_PLAYER],pGameStart->cbCardCount[INDEX_PLAYER],
		pGameStart->cbTableCardArray[INDEX_BANKER],pGameStart->cbCardCount[INDEX_BANKER]);

	//��������
	PlayGameSound(AfxGetInstanceHandle(),TEXT("GAME_START"));

	return true;
}

//�û���ע
bool CGameClientDlg::OnSubPlaceJetton(const void * pBuffer, WORD wDataSize)
{
	//Ч������
	ASSERT(wDataSize==sizeof(CMD_S_PlaceJetton));
	if (wDataSize!=sizeof(CMD_S_PlaceJetton)) return false;

	//��Ϣ����
	CMD_S_PlaceJetton * pPlaceJetton=(CMD_S_PlaceJetton *)pBuffer;

	//��������
	PlayGameSound(AfxGetInstanceHandle(),TEXT("ADD_GOLD"));

	//��ע����
	m_GameClientView.PlaceUserJetton(pPlaceJetton->cbJettonArea,pPlaceJetton->lJettonScore);

	return true;
}

//��Ϸ����
bool CGameClientDlg::OnSubGameEnd(const void * pBuffer, WORD wDataSize)
{
	//Ч������
	ASSERT(wDataSize==sizeof(CMD_S_GameEnd));
	if (wDataSize!=sizeof(CMD_S_GameEnd)) return false;

	//��Ϣ����
	CMD_S_GameEnd * pGameEnd=(CMD_S_GameEnd *)pBuffer;

	//����״̬
	SetGameStatus(GS_FREE);
	KillTimer(IDI_DISPATCH_CARD);
	KillTimer(IDI_SHOW_GAME_RESULT);
	m_GameClientView.SetDispatchCardFalg(false);

	//���ñ���
	m_lMeTieScore=0L;
	m_lMeBankerScore=0L;
	m_lMePlayerScore=0L;
	m_lMeTieSamePointScore = 0L;
	m_lMeBankerKingScore = 0L;
	m_lMePlayerKingScore = 0L;
	m_lMeMaxScore=pGameEnd->lMeMaxScore;

	//���³ɼ�
	for ( WORD wUserIndex = 0; wUserIndex < MAX_CHAIR; ++wUserIndex )
	{
		tagUserData const *pUserData = GetUserData(wUserIndex);

		if ( pUserData == NULL ) continue;
		tagApplyUser ApplyUser ;

		//������Ϣ
		ApplyUser.lUserScore = pUserData->lScore;
		ApplyUser.strUserName = pUserData->szName;
		m_GameClientView.m_ApplyUser.UpdateUser( ApplyUser );
	}

	BYTE cbPlayerPoint=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_PLAYER],m_cbCardCount[INDEX_PLAYER]);
	BYTE cbBankerPoint=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_BANKER],m_cbCardCount[INDEX_BANKER]);

	enOperateResult OperateResult = enOperateResult_NULL;
	if ( 0 < m_GameClientView.m_lMeCurGameScore ) OperateResult = enOperateResult_Win;
	else if ( m_GameClientView.m_lMeCurGameScore < 0 ) OperateResult = enOperateResult_Lost;
	else OperateResult = enOperateResult_NULL;

	m_GameClientView.SetGameHistory(OperateResult, cbPlayerPoint, cbBankerPoint);

	//ׯ�ҽ��
	m_GameClientView.SetBankerTreasure(pGameEnd->lBankerTreasure);

	//״̬����
	m_bPlaying = false;

	//�����ע
	m_GameClientView.SetMeMaxScore(m_lMeMaxScore);
	m_GameClientView.SetMeTieScore(m_lMeTieScore);
	m_GameClientView.SetMeBankerScore(m_lMeBankerScore);
	m_GameClientView.SetMePlayerScore(m_lMePlayerScore);
	m_GameClientView.SetMeBankerKingScore(m_lMeBankerKingScore);
	m_GameClientView.SetMePlayerKingScore(m_lMePlayerKingScore);
	m_GameClientView.SetMeTieSamePointScore(m_lMeTieSamePointScore);

	//���ý���
	m_GameClientView.CleanUserJetton();
	m_GameClientView.SetWinnerSide(NULL,0xFF,0xFF);
	m_GameClientView.m_CardControl[INDEX_PLAYER].SetCardData(NULL,0);
	m_GameClientView.m_CardControl[INDEX_BANKER].SetCardData(NULL,0);

	KillTimer(IDI_SHOW_GAME_RESULT);
	m_GameClientView.SetShowGameFlag(false);
	m_strDispatchCardTips = TEXT("");
    m_GameClientView.SetDispatchCardTips(TEXT(""));

	m_GameClientView.SetHistoryScore(m_wDrawCount,m_lMeResultCount);

	//ׯ����Ϣ
	if ( m_wCurrentBanker != INVALID_CHAIR )
		m_GameClientView.SetBankerInfo(SwitchViewChairID(m_wCurrentBanker), pGameEnd->nBankerTime, pGameEnd->lBankerTotalScore);


	//���¿���
	UpdateButtonContron();

	//�˿���Ϣ
	ZeroMemory(m_cbCardCount,sizeof(m_cbCardCount));
	ZeroMemory(m_cbSendCount,sizeof(m_cbSendCount));
	ZeroMemory(m_cbTableCardArray,sizeof(m_cbTableCardArray));

	//��������
	PlayGameSound(AfxGetInstanceHandle(),TEXT("PLACE_JETTON"));

	//����ʱ��
	SetGameTimer(GetMeChairID(),IDI_PLACE_JETTON,pGameEnd->cbTimeLeave);

	return true;
}

//��Ϸ����
bool CGameClientDlg::OnSubGameScore(const void * pBuffer, WORD wDataSize)
{
	//Ч������
	ASSERT(wDataSize==sizeof(CMD_S_GameScore));
	if (wDataSize!=sizeof(CMD_S_GameScore)) return false;

	//��Ϣ����
	CMD_S_GameScore * pGameScore=(CMD_S_GameScore *)pBuffer;

	//��ʷ�ɼ�
	m_wDrawCount++;
	m_lMeResultCount+=pGameScore->lMeGameScore;

	//���óɼ�
	m_GameClientView.SetGameScore(pGameScore->lMeGameScore, pGameScore->lMeReturnScore, pGameScore->lBankerScore);

	m_GameClientView.SetMeTieScore(pGameScore->lMeTieScore);
	m_GameClientView.SetMeBankerScore(pGameScore->lMeBankerScore);
	m_GameClientView.SetMePlayerScore(pGameScore->lMePlayerScore);
	m_GameClientView.SetMeBankerKingScore(pGameScore->lMeBankerKingScore);
	m_GameClientView.SetMePlayerKingScore(pGameScore->lMePlayerKingScore);
	m_GameClientView.SetMeTieSamePointScore(pGameScore->lMeTieKingScore);

	//���ñ���
	m_lMeTieScore=pGameScore->lMeTieScore;
	m_lMeBankerScore=pGameScore->lMeBankerScore;
	m_lMePlayerScore=pGameScore->lMePlayerScore;
	m_lMeTieSamePointScore = pGameScore->lMeTieKingScore;
	m_lMeBankerKingScore = pGameScore->lMeBankerKingScore;
	m_lMePlayerKingScore = pGameScore->lMePlayerKingScore;

	return true;
}

//���¿���
void CGameClientDlg::UpdateButtonContron()
{
	if ((IsLookonMode()==false)&&(GetGameStatus()==GS_FREE) && m_wCurrentBanker != GetMeChairID() && m_wCurrentBanker != INVALID_CHAIR )
	{
		//�������
		LONG lCurrentJetton=m_GameClientView.GetCurrentJetton();
		LONG lLeaveScore=m_lMeMaxScore-m_lMeTieScore-m_lMeBankerScore-m_lMePlayerScore-m_lMeBankerKingScore-m_lMePlayerKingScore-
			m_lMeTieSamePointScore;

		//���ù��
		if (lCurrentJetton>lLeaveScore)
		{
			if (lLeaveScore>=500000L) m_GameClientView.SetCurrentJetton(500000L);
			else if (lLeaveScore>=100000L) m_GameClientView.SetCurrentJetton(100000L);
			else if (lLeaveScore>=50000L) m_GameClientView.SetCurrentJetton(50000L);
			else if (lLeaveScore>=10000L) m_GameClientView.SetCurrentJetton(10000L);
			else if (lLeaveScore>=1000L) m_GameClientView.SetCurrentJetton(1000L);
			else if (lLeaveScore>=500L) m_GameClientView.SetCurrentJetton(500L);
			else if (lLeaveScore>=100L) m_GameClientView.SetCurrentJetton(100L);
			else m_GameClientView.SetCurrentJetton(0L);
		}

		//���ư�ť
		m_GameClientView.m_btJetton100.EnableWindow((lLeaveScore>=100)?TRUE:FALSE);
		m_GameClientView.m_btJetton500.EnableWindow((lLeaveScore>=500)?TRUE:FALSE);
		m_GameClientView.m_btJetton1000.EnableWindow((lLeaveScore>=1000)?TRUE:FALSE);
		m_GameClientView.m_btJetton10000.EnableWindow((lLeaveScore>=10000)?TRUE:FALSE);
		m_GameClientView.m_btJetton50000.EnableWindow((lLeaveScore>=50000)?TRUE:FALSE);		
		m_GameClientView.m_btJetton100000.EnableWindow((lLeaveScore>=100000)?TRUE:FALSE);
		m_GameClientView.m_btJetton500000.EnableWindow((lLeaveScore>=500000)?TRUE:FALSE);

	}
	else
	{
		//���ù��
		m_GameClientView.SetCurrentJetton(0L);

		//��ֹ��ť
		m_GameClientView.m_btJetton100.EnableWindow(FALSE);
		m_GameClientView.m_btJetton1000.EnableWindow(FALSE);
		m_GameClientView.m_btJetton10000.EnableWindow(FALSE);
		m_GameClientView.m_btJetton100000.EnableWindow(FALSE);
		m_GameClientView.m_btJetton500.EnableWindow(FALSE);
		m_GameClientView.m_btJetton50000.EnableWindow(FALSE);
		m_GameClientView.m_btJetton500000.EnableWindow(FALSE);
	}

	//���밴ť
	if ( ! IsLookonMode() )
	{
		//״̬�ж�
		if ( GetGameStatus()==GS_FREE ) 
		{
			m_GameClientView.m_btCancelBanker.EnableWindow(TRUE);
			m_GameClientView.m_btApplyBanker.EnableWindow(TRUE);
		}
		else
		{
			m_GameClientView.m_btCancelBanker.EnableWindow(FALSE);
			m_GameClientView.m_btApplyBanker.EnableWindow(FALSE);
		}

		//��ʾ�ж�
		const tagUserData *pMeUserData = GetUserData( GetMeChairID() );
		if ( m_bMeApplyBanker )
		{
			m_GameClientView.m_btCancelBanker.ShowWindow(SW_SHOW);
			m_GameClientView.m_btApplyBanker.ShowWindow(SW_HIDE);

			bool bMeBanker = pMeUserData->wChairID == m_wCurrentBanker ? true : false;
			if ( bMeBanker ) m_GameClientView.m_btCancelBanker.SetButtonImage(IDB_BT_CANCEL_BANKER,AfxGetInstanceHandle(),false);
			else m_GameClientView.m_btCancelBanker.SetButtonImage(IDB_BT_CANCEL_APPLY,AfxGetInstanceHandle(),false);

		}
		else if ( m_lApplyBankerCondition <= pMeUserData->lScore )
		{
			m_GameClientView.m_btCancelBanker.ShowWindow(SW_HIDE);
			m_GameClientView.m_btApplyBanker.ShowWindow(SW_SHOW);
		}
	}

	return;
}

//�ɷ��˿�
bool CGameClientDlg::DispatchUserCard(BYTE cbPlayerCard[], BYTE cbPlayerCount, BYTE cbBankerCard[], BYTE cbBankerCount)
{
	//Ч�����
	ASSERT(cbPlayerCount<=CountArray(m_cbTableCardArray[INDEX_PLAYER]));
	ASSERT(cbBankerCount<=CountArray(m_cbTableCardArray[INDEX_BANKER]));

	//���ñ���
	m_cbSendCount[INDEX_PLAYER]=0;
	m_cbSendCount[INDEX_BANKER]=0;
	m_cbCardCount[INDEX_PLAYER]=cbPlayerCount;
	m_cbCardCount[INDEX_BANKER]=cbBankerCount;
	CopyMemory(m_cbTableCardArray[INDEX_PLAYER],cbPlayerCard,sizeof(BYTE)*cbPlayerCount);
	CopyMemory(m_cbTableCardArray[INDEX_BANKER],cbBankerCard,sizeof(BYTE)*cbBankerCount);

	//���ý���
	m_GameClientView.m_CardControl[INDEX_PLAYER].SetCardData(NULL,0);
	m_GameClientView.m_CardControl[INDEX_BANKER].SetCardData(NULL,0);
	m_GameClientView.SetDispatchCardFalg(true);

	//���ö�ʱ��
	SetTimer(IDI_DISPATCH_CARD,1000,NULL);

	return true;
}

//��ʱ����Ϣ
void CGameClientDlg::OnTimer(UINT nIDEvent)
{
	switch (nIDEvent)
	{
	case IDI_DISPATCH_CARD:		//�ɷ��˿�
		{
			m_GameClientView.m_CardControl[0].ShowWindow(SW_SHOW);
			m_GameClientView.m_CardControl[1].ShowWindow(SW_SHOW);

			//�����˿�
			if ((m_cbSendCount[0]+m_cbSendCount[1])<4)
			{
				//��������
				WORD wIndex=(m_cbSendCount[0]+m_cbSendCount[1])%2;

				//�����˿�
				m_cbSendCount[wIndex]++;
				m_GameClientView.m_CardControl[wIndex].SetCardData(m_cbTableCardArray[wIndex],m_cbSendCount[wIndex]);

				//���½���
				m_GameClientView.UpdateGameView(NULL);

				//��������
				PlayGameSound(AfxGetInstanceHandle(),TEXT("SEND_CARD"));

				return;
			}

			//�����˿�
			if (m_cbSendCount[INDEX_PLAYER]<m_cbCardCount[INDEX_PLAYER])
			{
				//�����˿�
				m_cbSendCount[INDEX_PLAYER]++;
				m_GameClientView.m_CardControl[INDEX_PLAYER].SetCardData(m_cbTableCardArray[INDEX_PLAYER],m_cbSendCount[INDEX_PLAYER]);

				//��������
				PlayGameSound(AfxGetInstanceHandle(),TEXT("SEND_CARD"));

				//������ʾ
				SetDispatchCardTips();

				return;
			}

			//ׯ���˿�
			if (m_cbSendCount[INDEX_BANKER]<m_cbCardCount[INDEX_BANKER])
			{
				//�����˿�
				m_cbSendCount[INDEX_BANKER]++;
				m_GameClientView.m_CardControl[INDEX_BANKER].SetCardData(m_cbTableCardArray[INDEX_BANKER],m_cbSendCount[INDEX_BANKER]);

				//��������
				PlayGameSound(AfxGetInstanceHandle(),TEXT("SEND_CARD"));

				
				//������ʾ
				SetDispatchCardTips();

				return;
			}

			//��ȡ�Ƶ�
			BYTE cbPlayerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_PLAYER],m_cbCardCount[INDEX_PLAYER]);
			BYTE cbBankerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_BANKER],m_cbCardCount[INDEX_BANKER]);

			//����ʤ��
			BYTE cbWinnerSide=ID_PING_JIA, cbKingWinner=0;
			DeduceWinner(cbWinnerSide, cbKingWinner);

			//ʤ���ַ�
			TCHAR szGameResult[128]=TEXT("");
			LPCTSTR pszWinnerSide[]={TEXT("��ʤ"),TEXT("ƽʤ"),TEXT("ׯʤ")};
			int nIndex = 0;
			if (cbPlayerCount>cbBankerCount) nIndex = 0;
			else if (cbBankerCount>cbPlayerCount) nIndex = 2;
			else nIndex = 1;
			_sntprintf(szGameResult,CountArray(szGameResult),TEXT("�У�%d�㣬ׯ��%d�㣬%s"),cbPlayerCount,cbBankerCount, pszWinnerSide[nIndex]);

			m_strDispatchCardTips += szGameResult;
			m_GameClientView.SetDispatchCardTips(m_strDispatchCardTips);

			//���ý���
			m_GameClientView.SetWinnerSide(szGameResult,cbWinnerSide,cbKingWinner);
			m_GameClientView.SetDispatchCardFalg(false);

			//ɾ��ʱ��
			KillTimer(IDI_DISPATCH_CARD);

			//����ʱ��
			m_nShowResultTime = 15;
			SetTimer(IDI_SHOW_GAME_RESULT, 1000, NULL);
			m_GameClientView.SetShowGameFlag(true);
			m_GameClientView.m_CardControl[0].ShowWindow(SW_HIDE);
			m_GameClientView.m_CardControl[1].ShowWindow(SW_HIDE);

			//����ʣ��
			PlayGameSound(AfxGetInstanceHandle(),TEXT("GAME_END"));

			return;
		}
	case IDI_SHOW_GAME_RESULT:
		{
			m_nShowResultTime--;
			if ( m_nShowResultTime <= 0 )
			{
				KillTimer(IDI_SHOW_GAME_RESULT);
				m_GameClientView.SetShowGameFlag(false);
			}
			return;
		}
	}

	__super::OnTimer(nIDEvent);
}

//��ע��Ϣ
LRESULT CGameClientDlg::OnPlaceJetton(WPARAM wParam, LPARAM lParam)
{
	//��������
	BYTE cbJettonArea=(BYTE)wParam;
	LONG lJettonScore=(LONG)lParam;

	//ׯ���ж�
	if ( GetMeChairID() == m_wCurrentBanker ) return true;
	if ( m_wCurrentBanker == INVALID_CHAIR ) 
	{
		UpdateButtonContron();
		return true;
	}

	//���ñ���
	switch (cbJettonArea)
	{
		case ID_XIAN_JIA:
			{
				m_lMePlayerScore += lJettonScore;
				m_GameClientView.SetMePlayerScore(m_lMePlayerScore);
				break;
			}
		case ID_PING_JIA:
			{
				m_lMeTieScore += lJettonScore;
				m_GameClientView.SetMeTieScore(m_lMeTieScore);
				break;
			}
		case ID_ZHUANG_JIA:
			{
				m_lMeBankerScore += lJettonScore;
				m_GameClientView.SetMeBankerScore(m_lMeBankerScore);
				break;
			}
		case ID_TONG_DIAN_PING:
			{
				m_lMeTieSamePointScore += lJettonScore;
				m_GameClientView.SetMeTieSamePointScore(m_lMeTieSamePointScore);
				break;
			}
		case ID_XIAN_TIAN_WANG:
			{
				m_lMePlayerKingScore += lJettonScore;
				m_GameClientView.SetMePlayerKingScore(m_lMePlayerKingScore);
				break;
			}
		case ID_ZHUANG_TIAN_WANG:
			{
				m_lMeBankerKingScore += lJettonScore;
				m_GameClientView.SetMeBankerKingScore(m_lMeBankerKingScore);
				break;
			}
		}

	//��������
	CMD_C_PlaceJetton PlaceJetton;
	ZeroMemory(&PlaceJetton,sizeof(PlaceJetton));

	//�������
	PlaceJetton.cbJettonArea=cbJettonArea;
	PlaceJetton.lJettonScore=lJettonScore;

	//������Ϣ
	SendData(SUB_C_PLACE_JETTON,&PlaceJetton,sizeof(PlaceJetton));

	//���°�ť
	UpdateButtonContron();

	//����״̬
	m_bPlaying = true;

	return 0;
}

//������Ϣ
LRESULT CGameClientDlg::OnApplyBanker(WPARAM wParam, LPARAM lParam)
{
	//�Ϸ��ж�
	tagUserData const *pMeUserData = GetUserData( GetMeChairID() );
	if ( pMeUserData->lScore < m_lApplyBankerCondition ) return true;

	//�Թ��ж�
	if ( IsLookonMode() ) return true;

	//ת������
	bool bApplyBanker = wParam != 0 ? true : false;

	//��ǰ�ж�
	if ( m_wCurrentBanker == GetMeChairID() && bApplyBanker ) return true;

	CMD_C_ApplyBanker ApplyBanker;

	//��ֵ����
	ApplyBanker.bApplyBanker = bApplyBanker;

	//������Ϣ
	SendData( SUB_C_APPLY_BANKER, &ApplyBanker, sizeof( ApplyBanker ) );

	//���ð�ť
	if ( m_wCurrentBanker == GetMeChairID() && !bApplyBanker )
	{
		m_GameClientView.m_btCancelBanker.EnableWindow(FALSE);
	}

	return true;
}

//������ׯ
bool CGameClientDlg::OnUserApplyBanker(const void * pBuffer, WORD wDataSize)
{
	//Ч������
	ASSERT(wDataSize==sizeof(CMD_S_ApplyBanker));
	if (wDataSize!=sizeof(CMD_S_ApplyBanker)) return false;

	//��Ϣ����
	CMD_S_ApplyBanker * pApplyBanker=(CMD_S_ApplyBanker *)pBuffer;

	//�������
	if ( pApplyBanker->bApplyBanker )
	{
		tagApplyUser ApplyUser;
		ApplyUser.strUserName = pApplyBanker->szAccount;
		ApplyUser.lUserScore = pApplyBanker->lScore;

		//�����ж�
		bool bInsertApplyUser = true;

		if ( m_wCurrentBanker != INVALID_CHAIR )
		{
			tagUserData const *pBankerUserData = GetUserData(m_wCurrentBanker);
			if ( pBankerUserData != NULL && 0==lstrcmp(pBankerUserData->szName, pApplyBanker->szAccount))
				bInsertApplyUser = false;
		}

		if ( bInsertApplyUser == true ) m_GameClientView.m_ApplyUser.InserUser( ApplyUser );

		//������ť
		tagUserData const *pUserData = GetUserData( GetMeChairID() );
		if ( pUserData && !strcmp(pApplyBanker->szAccount, pUserData->szName ) )
		{
			m_bMeApplyBanker = true;
			UpdateButtonContron();
		}
	}
	else
	{
		tagApplyUser ApplyUser;
		ApplyUser.strUserName = pApplyBanker->szAccount;
		ApplyUser.lUserScore = pApplyBanker->lScore;
		m_GameClientView.m_ApplyUser.DeleteUser( ApplyUser );

		//������ť
		tagUserData const *pUserData = GetUserData( GetMeChairID() );
		if ( pUserData &&  !strcmp(pApplyBanker->szAccount, pUserData->szName ) )
		{
			m_bMeApplyBanker = false;
			
			UpdateButtonContron();
		}
	}

	return true;
}

//�л�ׯ��
bool CGameClientDlg::OnChangeBanker(const void * pBuffer, WORD wDataSize)
{
	//Ч������
	ASSERT(wDataSize==sizeof(CMD_S_ChangeBanker));
	if (wDataSize!=sizeof(CMD_S_ChangeBanker)) return false;

	//��Ϣ����
	CMD_S_ChangeBanker * pChangeBanker=(CMD_S_ChangeBanker *)pBuffer;

	//��ʾͼƬ
	m_GameClientView.ShowChangeBanker( m_wCurrentBanker != pChangeBanker->wChairID );

	//�Լ��ж�
	if ( m_wCurrentBanker == GetMeChairID() && IsLookonMode() == false && pChangeBanker->wChairID != GetMeChairID() ) 
	{
		m_bMeApplyBanker = false;
	}

	m_wCurrentBanker = pChangeBanker->wChairID;

	//ׯ����Ϣ
	if ( pChangeBanker->wChairID == INVALID_CHAIR )
	{
		m_GameClientView.SetBankerInfo( INVALID_CHAIR, pChangeBanker->cbBankerTime, pChangeBanker->lBankerScore );
	}
	else
	{
		m_GameClientView.SetBankerInfo( SwitchViewChairID( pChangeBanker->wChairID ), pChangeBanker->cbBankerTime, 0 );
	}
	m_GameClientView.SetBankerTreasure(pChangeBanker->lBankerTreasure);

	//ɾ�����
	if ( m_wCurrentBanker != INVALID_CHAIR )
	{
		tagUserData const *pBankerUserData = GetUserData(m_wCurrentBanker);
		if ( pBankerUserData != NULL )
		{
			tagApplyUser ApplyUser;
			ApplyUser.strUserName = pBankerUserData->szName;
			m_GameClientView.m_ApplyUser.DeleteUser( ApplyUser );
		}
	}
	
	//���½���
	UpdateButtonContron();

	return true;
}

//���»���
bool CGameClientDlg::OnChangeUserScore(const void * pBuffer, WORD wDataSize)
{
	//Ч������
	ASSERT(wDataSize==sizeof(CMD_S_ChangeUserScore));
	if (wDataSize!=sizeof(CMD_S_ChangeUserScore)) return false;

	//��Ϣ����
	CMD_S_ChangeUserScore * pChangeUserScore=(CMD_S_ChangeUserScore *)pBuffer;

	tagUserData const *pUserData = GetUserData( pChangeUserScore->wChairID );

	if ( pUserData )
	{
		tagApplyUser ApplyUser ;

		ApplyUser.lUserScore = pChangeUserScore->lScore;
		ApplyUser.strUserName = pUserData->szName;
		m_GameClientView.m_ApplyUser.UpdateUser( ApplyUser );
	}

	//ׯ����Ϣ
	if ( m_wCurrentBanker == pChangeUserScore->wCurrentBankerChairID )
	{
		m_GameClientView.SetBankerInfo( SwitchViewChairID( pChangeUserScore->wCurrentBankerChairID ), pChangeUserScore->cbBankerTime, pChangeUserScore->lCurrentBankerScore );

		//���½���
		UpdateButtonContron();
	}

	return true;
}

//ȡ����Ϣ
void CGameClientDlg::OnCancel()
{
	tagUserData const *pMeUserData = GetUserData( GetMeChairID() );
	if ( pMeUserData != NULL && pMeUserData->cbUserStatus != US_PLAY && m_bPlaying != false )
	{
		int iRet=AfxMessageBox(TEXT("��������Ϸ�У�ǿ���˳������۷֣�ȷʵҪǿ����"),MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2);
		if (iRet!=IDYES) return;
	}

	__super::OnCancel();
}

//��Ϸ��¼
bool CGameClientDlg::OnSubGameRecord(const void * pBuffer, WORD wDataSize)
{
	//Ч�����
	ASSERT(wDataSize%sizeof(tagServerGameRecord)==0);
	if (wDataSize%sizeof(tagServerGameRecord)!=0) return false;
	
	//�������
	tagGameRecord GameRecord;
	ZeroMemory(&GameRecord,sizeof(GameRecord));

	//���ü�¼
	WORD wRecordCount=wDataSize/sizeof(tagServerGameRecord);
	for (WORD wIndex=0;wIndex<wRecordCount;wIndex++) 
	{
		tagServerGameRecord * pServerGameRecord=(((tagServerGameRecord *)pBuffer)+wIndex);

		m_GameClientView.SetGameHistory(enOperateResult_NULL, pServerGameRecord->cbPlayerCount, pServerGameRecord->cbBankerCount);
	}

	return true;
}

//������ʾ
void CGameClientDlg::SetDispatchCardTips()
{
	//�������
	BYTE cbBankerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_BANKER],2);
	BYTE cbPlayerTwoCardCount = m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_PLAYER],2);

	//�мҲ���
	BYTE cbPlayerThirdCardValue = 0 ;	//�������Ƶ���
	if(cbPlayerTwoCardCount<=5 && cbBankerCount<8)
	{
		//�������
		cbPlayerThirdCardValue = m_GameLogic.GetCardPip(m_cbTableCardArray[INDEX_PLAYER][2]);
		CString strTips;
		strTips.Format(TEXT("��%d�㣬ׯ%d�㣬�м�������\n"), cbPlayerTwoCardCount, cbBankerCount);
		m_strDispatchCardTips = strTips;
		m_GameClientView.SetDispatchCardTips(m_strDispatchCardTips);
	}

	//ׯ�Ҳ���
	CString strTips;
	if(cbPlayerTwoCardCount<8 && cbBankerCount<8 && m_cbSendCount[INDEX_BANKER] == 3)
	{
		switch(cbBankerCount)
		{
		case 0:
		case 1:
		case 2:
			break;

		case 3:
			if(m_cbCardCount[INDEX_PLAYER]==3 && cbPlayerThirdCardValue!=8)
			{
				strTips.Format(TEXT("�е�������%d�㣬ׯ%d�㣬ׯ��������\n"), cbPlayerThirdCardValue, cbBankerCount);
				m_strDispatchCardTips += strTips;
				m_GameClientView.SetDispatchCardTips(m_strDispatchCardTips);
			}
			else if (m_cbCardCount[INDEX_PLAYER]==2) 
			{
				strTips.Format(TEXT("�в����ƣ�ׯ%d�㣬ׯ��������\n"), cbBankerCount);
				m_strDispatchCardTips += strTips;
				m_GameClientView.SetDispatchCardTips(m_strDispatchCardTips);
			}			
			break;

		case 4:
			if(m_cbCardCount[INDEX_PLAYER]==3 && cbPlayerThirdCardValue!=1 && cbPlayerThirdCardValue!=8 && cbPlayerThirdCardValue!=9 && cbPlayerThirdCardValue!=0)
			{
				strTips.Format(TEXT("�е�������%d�㣬ׯ%d�㣬ׯ��������\n"), cbPlayerThirdCardValue, cbBankerCount);
				m_strDispatchCardTips += strTips;
				m_GameClientView.SetDispatchCardTips(m_strDispatchCardTips);
			}
			else if ( m_cbCardCount[INDEX_PLAYER]==2) 
			{
				strTips.Format(TEXT("�в����ƣ�ׯ%d�㣬ׯ��������\n"), cbBankerCount);
				m_strDispatchCardTips += strTips;
				m_GameClientView.SetDispatchCardTips(m_strDispatchCardTips);
			}
			break;

		case 5:
			if(m_cbCardCount[INDEX_PLAYER]==3 && cbPlayerThirdCardValue!=1 && cbPlayerThirdCardValue!=2 && cbPlayerThirdCardValue!=3  && cbPlayerThirdCardValue!=8 && cbPlayerThirdCardValue!=9 &&  cbPlayerThirdCardValue!=0)
			{
				strTips.Format(TEXT("�е�������%d�㣬ׯ%d�㣬ׯ��������\n"), cbPlayerThirdCardValue, cbBankerCount);
				m_strDispatchCardTips += strTips;
				m_GameClientView.SetDispatchCardTips(m_strDispatchCardTips);
			}
			else if ( m_cbCardCount[INDEX_PLAYER]==2) 
			{
				strTips.Format(TEXT("�в����ƣ�ׯ%d�㣬ׯ��������\n"), cbBankerCount);
				m_strDispatchCardTips += strTips;
				m_GameClientView.SetDispatchCardTips(m_strDispatchCardTips);
			}
			break;

		case 6:
			if(m_cbCardCount[INDEX_PLAYER]==3 && (cbPlayerThirdCardValue==6 || cbPlayerThirdCardValue==7))
			{
				strTips.Format(TEXT("�е�������%d�㣬ׯ%d�㣬ׯ��������\n"), cbPlayerThirdCardValue, cbBankerCount);
				m_strDispatchCardTips += strTips;
				m_GameClientView.SetDispatchCardTips(m_strDispatchCardTips);
			}
			break;

			//���벹��
		case 7:
		case 8:
		case 9:
			break;
		default:
			break;
		}
	}

	return ;
}


//�ƶ�Ӯ��
void CGameClientDlg::DeduceWinner(BYTE &cbWinner, BYTE &cbKingWinner)
{
	cbWinner = 0;
	cbKingWinner = 0;

	//�����Ƶ�
	BYTE cbPlayerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_PLAYER],m_cbCardCount[INDEX_PLAYER]);
	BYTE cbBankerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_BANKER],m_cbCardCount[INDEX_BANKER]);

	//ʤ�����
	if (cbPlayerCount==cbBankerCount)
	{
		cbWinner=ID_PING_JIA;

		//ͬ��ƽ�ж�
		bool bAllPointSame = false;
		if ( m_cbCardCount[INDEX_PLAYER] == m_cbCardCount[INDEX_BANKER] )
		{
			for (WORD wCardIndex = 0; wCardIndex < m_cbCardCount[INDEX_PLAYER]; ++wCardIndex )
			{
				BYTE cbBankerValue = m_GameLogic.GetCardValue(m_cbTableCardArray[INDEX_BANKER][wCardIndex]);
				BYTE cbPlayerValue = m_GameLogic.GetCardValue(m_cbTableCardArray[INDEX_PLAYER][wCardIndex]);
				if ( cbBankerValue != cbPlayerValue ) break;
			}
			if ( wCardIndex == m_cbCardCount[INDEX_PLAYER] ) bAllPointSame = true;
		}
		if ( bAllPointSame ) cbKingWinner = ID_TONG_DIAN_PING;
	}
	else if (cbPlayerCount<cbBankerCount) 
	{
		cbWinner=ID_ZHUANG_JIA;

		//�����ж�
		if ( cbBankerCount == 8 || cbBankerCount == 9 ) cbKingWinner = ID_ZHUANG_TIAN_WANG;
	}
	else 
	{
		cbWinner=ID_XIAN_JIA;

		//�����ж�
		if ( cbPlayerCount == 8 || cbPlayerCount == 9 ) cbKingWinner = ID_XIAN_TIAN_WANG;
	}
}
//////////////////////////////////////////////////////////////////////////
